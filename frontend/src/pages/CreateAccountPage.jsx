import { useEffect, useState } from "react";
import { registerAccount, searchOrganizations } from "../services/auth";
import "./login-page.css";

export function CreateAccountPage({ onBackToLogin }) {
  // Campos exigidos pelo endpoint atual de criacao de conta.
  // O formulario foi mantido simples porque o foco do projeto nao e onboarding,
  // e sim a camada de visualizacao dos resultados.
  const [form, setForm] = useState({
    username: "",
    email: "",
    password: "",
    role: "",
    organization_id: "",
    organization_name: "",
    organization_description: ""
  });

  // Estados visuais de feedback do processo de cadastro.
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [organizationSuggestions, setOrganizationSuggestions] = useState([]);
  const [isSearchingOrganizations, setIsSearchingOrganizations] = useState(false);

  // Atualiza qualquer campo do formulario de acordo com o "name" do input.
  function handleChange(event) {
    const { name, value } = event.target;
    setForm((prev) => ({
      ...prev,
      [name]: value,
      ...(name === "organization_name" ? { organization_id: "" } : {})
    }));
  }

  useEffect(() => {
    const query = form.organization_name.trim();
    if (form.organization_id || query.length < 2) {
      setOrganizationSuggestions([]);
      setIsSearchingOrganizations(false);
      return undefined;
    }

    let ignore = false;
    const timerId = window.setTimeout(async () => {
      setIsSearchingOrganizations(true);

      try {
        const suggestions = await searchOrganizations(query);
        if (!ignore) {
          setOrganizationSuggestions(suggestions);
        }
      } catch {
        if (!ignore) {
          setOrganizationSuggestions([]);
        }
      } finally {
        if (!ignore) {
          setIsSearchingOrganizations(false);
        }
      }
    }, 250);

    return () => {
      ignore = true;
      window.clearTimeout(timerId);
    };
  }, [form.organization_id, form.organization_name]);

  function handleOrganizationSelect(organization) {
    setForm((prev) => ({
      ...prev,
      organization_id: organization.id,
      organization_name: organization.name
    }));
    setOrganizationSuggestions([]);
  }

  // Volta para o login.
  // Se a tela foi aberta pelo App, usamos o callback; caso contrario, usamos o hash como fallback.
  function handleBackToLogin() {
    if (typeof onBackToLogin === "function") {
      onBackToLogin();
      return;
    }

    window.location.hash = "";
  }

  // Envia os dados para a API de cadastro e controla o feedback local da tela.
  async function handleSubmit(event) {
    event.preventDefault();
    setError("");
    setSuccess("");
    setIsLoading(true);

    try {
      await registerAccount(form);
      setSuccess("Account created successfully. You can sign in now.");
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <main className="login-shell">
      <section className="login-layout">
        {/* Coluna institucional, reaproveitando a mesma linguagem visual do login
            para manter consistencia na entrada da plataforma. */}
        <aside className="promo-panel">
          <div className="promo-content">
            <img className="brand-logo" src="/branding/logo-zeppelin.png" alt="Zeppelin CI/CD" />
            <h1>
              Build your team profile with <span>clarity</span>.
            </h1>
            <p>
              Create your account, link your organization, and start measuring CI/CD maturity from
              day one.
            </p>
          </div>
        </aside>

        <section className="login-panel">
          <section className="login-card">
            <header>
              <h2>Create your Zeppelin account</h2>
              <p>Use your work details to set up access for your team.</p>
            </header>

            {error ? <p className="feedback error">{error}</p> : null}
            {success ? <p className="feedback success">{success}</p> : null}

            <form onSubmit={handleSubmit} className="login-form">
              {/* Dados pessoais e organizacionais minimos para criacao da conta. */}
              <label htmlFor="username">Full name</label>
              <input
                id="username"
                name="username"
                type="text"
                value={form.username}
                onChange={handleChange}
                required
                placeholder="John Doe"
              />

              <label htmlFor="email">Work email</label>
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

              <label htmlFor="role">Role</label>
              <input
                id="role"
                name="role"
                type="text"
                value={form.role}
                onChange={handleChange}
                placeholder="Engineering Manager"
              />

              <label htmlFor="organization_name">Organization name</label>
              <input
                id="organization_name"
                name="organization_name"
                type="text"
                value={form.organization_name}
                onChange={handleChange}
                required
                placeholder="Zeppelin Labs"
              />
              {form.organization_id ? (
                <p className="typeahead-note success">
                  Existing organization selected. The account will be linked to this record.
                </p>
              ) : null}
              {isSearchingOrganizations ? (
                <p className="typeahead-note">Searching existing organizations...</p>
              ) : null}
              {!form.organization_id && organizationSuggestions.length > 0 ? (
                <div className="typeahead-list" role="listbox" aria-label="Organization suggestions">
                  {organizationSuggestions.map((organization) => (
                    <button
                      key={organization.id}
                      type="button"
                      className="typeahead-option"
                      onClick={() => handleOrganizationSelect(organization)}
                    >
                      <strong>{organization.name}</strong>
                      <span>Select existing organization</span>
                    </button>
                  ))}
                </div>
              ) : null}
              {!form.organization_id &&
              !isSearchingOrganizations &&
              form.organization_name.trim().length >= 2 &&
              organizationSuggestions.length === 0 ? (
                <p className="typeahead-note">
                  No existing organization matched this name. A new record will be created.
                </p>
              ) : null}

              <label htmlFor="organization_description">Organization description (optional)</label>
              <textarea
                id="organization_description"
                name="organization_description"
                value={form.organization_description}
                onChange={handleChange}
                placeholder="Short description about your organization"
                rows={3}
              />

              <button className="btn-primary" type="submit" disabled={isLoading}>
                {isLoading ? "Creating account..." : "Create Account"}
              </button>

              {/* Separador para destacar a acao de retorno ao login. */}
              <div className="separator">
                <span>Already have an account?</span>
              </div>

              <button className="btn-secondary" type="button" onClick={handleBackToLogin}>
                Back to Sign In
              </button>
            </form>

            <footer>
              {/* Rodape institucional placeholder. */}
              <a href="#">Privacy Policy</a>
              <a href="#">Terms of Service</a>
            </footer>
          </section>
        </section>
      </section>
    </main>
  );
}
