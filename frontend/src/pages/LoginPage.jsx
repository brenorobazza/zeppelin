import { useState } from "react";
import { loginWithEmail, requestPasswordReset } from "../services/auth";
import "./login-page.css";

export function LoginPage({ onCreateAccountClick, onLoginSuccess }) {
  // Estado local para os campos do formulario principal de login.
  // Esses valores sao controlados pelo React para que a interface saiba sempre
  // o que o usuario digitou.
  const [form, setForm] = useState({ email: "", password: "" });

  // Estados visuais de feedback da tela.
  // Eles servem para mostrar sucesso, erro e carregamento sem depender do backend renderizar HTML.
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [success, setSuccess] = useState("");

  // Estados do fluxo "Forgot password?".
  // Esse bloco foi separado do login principal para nao poluir o formulario inicial.
  const [showForgotPassword, setShowForgotPassword] = useState(false);
  const [recoveryEmail, setRecoveryEmail] = useState("");
  const [recoveryError, setRecoveryError] = useState("");
  const [recoverySuccess, setRecoverySuccess] = useState("");
  const [isRecoveryLoading, setIsRecoveryLoading] = useState(false);

  // Atualiza dinamicamente o campo alterado (email ou password) sem precisar
  // criar uma funcao separada para cada input.
  function handleChange(event) {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  }

  // Encaminha o usuario para a tela de criacao de conta.
  // Se a navegacao vier do App, usamos o callback; se nao vier, usamos o hash como fallback.
  function handleCreateAccount() {
    if (typeof onCreateAccountClick === "function") {
      onCreateAccountClick();
      return;
    }

    window.location.hash = "create-account";
  }

  // Dispara o fluxo de recuperacao de senha.
  // Primeiro tenta usar o email digitado no bloco de recuperacao; se ele estiver vazio,
  // reaproveita o email ja preenchido no formulario principal.
  async function handleForgotPassword(event) {
    event.preventDefault();
    setRecoveryError("");
    setRecoverySuccess("");
    setIsRecoveryLoading(true);

    try {
      const emailToUse = (recoveryEmail || form.email || "").trim();
      const data = await requestPasswordReset(emailToUse);
      setRecoverySuccess(
        data.message || "If the account exists, password recovery instructions were sent."
      );
    } catch (err) {
      // Se o backend rejeitar a operacao, mostramos o erro logo abaixo do campo.
      setRecoveryError(err.message);
    } finally {
      setIsRecoveryLoading(false);
    }
  }

  // Faz o login via API e controla loading, sucesso e erro.
  // Se o backend autenticar o usuario, devolvemos esse resultado para o App decidir
  // qual sera a proxima tela do fluxo.
  async function handleSubmit(event) {
    event.preventDefault();
    setError("");
    setSuccess("");
    setIsLoading(true);

    try {
      const user = await loginWithEmail(form);
      setSuccess(`Login successful. Welcome, ${user.username}.`);
      if (typeof onLoginSuccess === "function") {
        onLoginSuccess(user);
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <main className="login-shell">
      <section className="login-layout">
        {/* Coluna de apresentacao da marca.
            Essa area contextualiza o produto antes mesmo do login,
            reforcando o objetivo da plataforma para quem esta entrando. */}
        <aside className="promo-panel">
          <div className="promo-content">
            <img className="brand-logo" src="/branding/logo-zeppelin.png" alt="Zeppelin CI/CD" />
            <h1>
              Explore the practices you <span>master</span>.
            </h1>
            <p>
              Zeppelin helps your team measure CI/CD maturity, identify bottlenecks, and evolve with
              confidence.
            </p>
          </div>
        </aside>

        {/* Coluna principal de autenticacao.
            Aqui fica toda a interacao de entrada do usuario: login, erro, sucesso e recuperacao. */}
        <section className="login-panel">
          <section className="login-card">
            <header>
              <h2>Sign in to Zeppelin</h2>
              <p>Use your work email to access the platform.</p>
            </header>

            {error ? <p className="feedback error">{error}</p> : null}
            {success ? <p className="feedback success">{success}</p> : null}

            <form onSubmit={handleSubmit} className="login-form">
              {/* Campos principais de autenticacao. */}
              <label htmlFor="email">Email</label>
              <input
                id="email"
                name="email"
                type="email"
                value={form.email}
                onChange={handleChange}
                required
                placeholder="you@company.com"
              />

              <label htmlFor="password">Password</label>
              <input
                id="password"
                name="password"
                type="password"
                value={form.password}
                onChange={handleChange}
                required
                placeholder="********"
              />

              <button className="btn-primary" type="submit" disabled={isLoading}>
                {isLoading ? "Signing in..." : "Log In"}
              </button>

              {/* O botao apenas expande ou recolhe o bloco de recuperacao.
                  Isso evita criar outra tela separada para uma interacao curta. */}
              <button
                className="text-link"
                type="button"
                onClick={() => {
                  setShowForgotPassword((value) => !value);
                  setRecoveryError("");
                  setRecoverySuccess("");
                  if (!recoveryEmail && form.email) {
                    setRecoveryEmail(form.email);
                  }
                }}
              >
                Forgot your password?
              </button>

              {showForgotPassword ? (
                // Bloco auxiliar para recuperacao de senha.
                // Ele aparece somente quando o usuario pede essa acao explicitamente.
                <div className="forgot-box">
                  <label htmlFor="recovery-email">Recovery email</label>
                  <input
                    id="recovery-email"
                    name="recovery-email"
                    type="email"
                    value={recoveryEmail}
                    onChange={(event) => setRecoveryEmail(event.target.value)}
                    required
                    placeholder="you@company.com"
                  />
                  {recoveryError ? <p className="feedback error">{recoveryError}</p> : null}
                  {recoverySuccess ? <p className="feedback success">{recoverySuccess}</p> : null}
                  <button
                    className="btn-secondary"
                    type="button"
                    disabled={isRecoveryLoading}
                    onClick={handleForgotPassword}
                  >
                    {isRecoveryLoading ? "Sending..." : "Send recovery email"}
                  </button>
                </div>
              ) : null}

              {/* Separador visual para deixar claro que o fluxo alternativo abaixo
                  nao faz parte do login em si, mas sim do cadastro. */}
              <div className="separator">
                <span>Don't have an account?</span>
              </div>

              <button className="btn-secondary" type="button" onClick={handleCreateAccount}>
                Create Account
              </button>
            </form>

            <footer>
              {/* Links institucionais de rodape.
                  Hoje sao apenas placeholders visuais para compor a interface. */}
              <a href="#">Privacy Policy</a>
              <a href="#">Terms of Service</a>
            </footer>
          </section>
        </section>
      </section>
    </main>
  );
}
