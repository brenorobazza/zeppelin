import { useState } from "react";
import { loginWithEmail } from "../services/auth";
import "./login-page.css";

export function LoginPage() {
  // Estado local para campos do formulario e mensagens de feedback.
  const [form, setForm] = useState({ email: "", password: "" });
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [success, setSuccess] = useState("");

  // Atualiza dinamicamente o campo alterado (email/password).
  function handleChange(event) {
    const { name, value } = event.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  }

  // Faz o login via API e controla estados de loading, sucesso e erro.
  async function handleSubmit(event) {
    event.preventDefault();
    setError("");
    setSuccess("");
    setIsLoading(true);

    try {
      const user = await loginWithEmail(form);
      setSuccess(`Login successful. Welcome, ${user.username}.`);
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <main className="login-shell">
      <section className="login-layout">
        {/* Coluna de apresentacao da marca */}
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

        {/* Coluna com o formulario de autenticacao */}
        <section className="login-panel">
          <section className="login-card">
            <header>
              <h2>Sign in to Zeppelin</h2>
              <p>Use your work email to access the platform.</p>
            </header>

            {error ? <p className="feedback error">{error}</p> : null}
            {success ? <p className="feedback success">{success}</p> : null}

            <form onSubmit={handleSubmit} className="login-form">
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

              <button className="text-link" type="button">
                Forgot your password?
              </button>

              <div className="separator">
                <span>Don't have an account?</span>
              </div>

              <button className="btn-secondary" type="button">
                Create Account
              </button>
            </form>

            <footer>
              <a href="#">Privacy Policy</a>
              <a href="#">Terms of Service</a>
            </footer>
          </section>
        </section>
      </section>
    </main>
  );
}
