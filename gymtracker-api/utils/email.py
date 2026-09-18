import requests
from flask import current_app


def send_reset_email(to_email: str, full_name: str, reset_link: str) -> None:
    """Envia o e-mail de redefinição de senha via Resend.

    Levanta exceção se a API key não estiver configurada ou se a Resend
    recusar o envio — quem chama decide se isso deve virar erro pro usuário
    ou só um log (ver modules/auth: não queremos confirmar por essa via se
    um e-mail existe ou não na base).
    """
    api_key = current_app.config.get("RESEND_API_KEY")
    if not api_key:
        raise RuntimeError("RESEND_API_KEY não configurada.")

    resp = requests.post(
        "https://api.resend.com/emails",
        headers={"Authorization": f"Bearer {api_key}"},
        json={
            "from": current_app.config.get("RESEND_FROM_EMAIL"),
            "to": [to_email],
            "subject": "Redefinir senha — GymTracker 16W",
            "html": f"""
                <p>Olá, {full_name}!</p>
                <p>Recebemos um pedido para redefinir a senha da sua conta no GymTracker 16W.</p>
                <p><a href="{reset_link}">Clique aqui para criar uma nova senha</a></p>
                <p>Esse link expira em 1 hora. Se você não pediu essa redefinição, pode ignorar
                este e-mail — sua senha atual continua valendo.</p>
            """,
        },
        timeout=10,
    )
    resp.raise_for_status()
