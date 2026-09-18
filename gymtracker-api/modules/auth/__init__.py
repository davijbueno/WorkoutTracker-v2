import hashlib
import secrets
import traceback
from datetime import datetime, timedelta

from flask import Blueprint, current_app, request, jsonify
from flask_jwt_extended import (
    create_access_token,
    create_refresh_token,
    jwt_required,
    get_jwt_identity,
)
from flask_bcrypt import generate_password_hash, check_password_hash
from marshmallow import ValidationError

import db
from utils.email import send_reset_email
from utils.validators import RegisterSchema, LoginSchema, ForgotPasswordSchema, ResetPasswordSchema

bp = Blueprint("auth", __name__)
register_schema = RegisterSchema()
login_schema = LoginSchema()
forgot_password_schema = ForgotPasswordSchema()
reset_password_schema = ResetPasswordSchema()

# Token de reset expira em 1h — prazo curto o bastante pra limitar o risco
# de um link vazado, longo o bastante pra não frustrar quem demora a abrir
# o e-mail.
RESET_TOKEN_TTL_MINUTES = 60


@bp.route("/register", methods=["POST"])
def register():
    try:
        data = register_schema.load(request.get_json() or {})
    except ValidationError as e:
        return jsonify({"error": "Dados inválidos.", "details": e.messages}), 400

    existing = db.query_one("SELECT id FROM users WHERE email = %s", (data["email"],))
    if existing:
        return jsonify({"error": "Este e-mail já está cadastrado."}), 409

    hashed = generate_password_hash(data["password"]).decode("utf-8")
    db.execute(
        "INSERT INTO users (email, password_hash, full_name) VALUES (%s, %s, %s)",
        (data["email"], hashed, data["full_name"]),
    )
    return jsonify({"message": "Conta criada com sucesso."}), 201


@bp.route("/login", methods=["POST"])
def login():
    try:
        data = login_schema.load(request.get_json() or {})
    except ValidationError as e:
        return jsonify({"error": "Dados inválidos.", "details": e.messages}), 400

    user = db.query_one(
        "SELECT * FROM users WHERE email = %s AND is_active = TRUE", (data["email"],)
    )
    if not user or not check_password_hash(user["password_hash"], data["password"]):
        return jsonify({"error": "E-mail ou senha inválidos."}), 401

    access_token = create_access_token(identity=str(user["id"]))
    refresh_token = create_refresh_token(identity=str(user["id"]))
    return jsonify(
        {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "user": {
                "id": user["id"],
                "email": user["email"],
                "full_name": user["full_name"],
            },
        }
    )


@bp.route("/refresh", methods=["POST"])
@jwt_required(refresh=True)
def refresh():
    identity = get_jwt_identity()
    access_token = create_access_token(identity=identity)
    return jsonify({"access_token": access_token})


@bp.route("/me", methods=["GET"])
@jwt_required()
def me():
    user_id = int(get_jwt_identity())
    user = db.query_one(
        "SELECT id, email, full_name, created_at FROM users WHERE id = %s", (user_id,)
    )
    if not user:
        return jsonify({"error": "Usuário não encontrado."}), 404
    return jsonify({"data": dict(user)})


# Mensagem sempre idêntica em /esqueci-senha, exista ou não o e-mail —
# senão a resposta vira um jeito fácil de descobrir quais e-mails têm conta.
_FORGOT_PASSWORD_MESSAGE = (
    "Se esse e-mail estiver cadastrado, enviamos um link para redefinir a senha."
)


@bp.route("/esqueci-senha", methods=["POST"])
def forgot_password():
    try:
        data = forgot_password_schema.load(request.get_json() or {})
    except ValidationError as e:
        return jsonify({"error": "Dados inválidos.", "details": e.messages}), 400

    user = db.query_one(
        "SELECT id, full_name FROM users WHERE email = %s AND is_active = TRUE",
        (data["email"],),
    )
    if user:
        token = secrets.token_urlsafe(32)
        token_hash = hashlib.sha256(token.encode("utf-8")).hexdigest()
        expires_at = datetime.utcnow() + timedelta(minutes=RESET_TOKEN_TTL_MINUTES)
        db.execute(
            "UPDATE users SET reset_token_hash=%s, reset_token_expires_at=%s WHERE id=%s",
            (token_hash, expires_at, user["id"]),
        )
        reset_link = f"{current_app.config['FRONTEND_URL']}/redefinir-senha?token={token}"
        try:
            send_reset_email(data["email"], user["full_name"], reset_link)
        except Exception:
            # Falha de envio não pode virar pista de que o e-mail existe —
            # loga pra investigar depois e responde a mesma mensagem genérica.
            traceback.print_exc()

    return jsonify({"message": _FORGOT_PASSWORD_MESSAGE})


@bp.route("/redefinir-senha", methods=["POST"])
def reset_password():
    try:
        data = reset_password_schema.load(request.get_json() or {})
    except ValidationError as e:
        return jsonify({"error": "Dados inválidos.", "details": e.messages}), 400

    token_hash = hashlib.sha256(data["token"].encode("utf-8")).hexdigest()
    user = db.query_one(
        """SELECT id FROM users
           WHERE reset_token_hash = %s AND reset_token_expires_at > NOW()""",
        (token_hash,),
    )
    if not user:
        return jsonify({"error": "Link inválido ou expirado. Solicite um novo."}), 400

    hashed = generate_password_hash(data["password"]).decode("utf-8")
    db.execute(
        """UPDATE users SET password_hash=%s, reset_token_hash=NULL,
           reset_token_expires_at=NULL, updated_at=NOW() WHERE id=%s""",
        (hashed, user["id"]),
    )
    return jsonify({"message": "Senha redefinida com sucesso. Faça login com a nova senha."})
