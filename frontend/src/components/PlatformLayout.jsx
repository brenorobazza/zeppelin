import "./platform-layout.css";

const navItems = [
  { key: "dashboard", label: "Dashboard" },
  { key: "assessment", label: "Assessment" },
  { key: "results", label: "Results" },
  { key: "recommendations", label: "Recommendations" },
  { key: "history", label: "History" },
  { key: "settings", label: "Organization Settings" }
];

export function PlatformLayout({
  activePage,
  title,
  subtitle,
  organization,
  userName,
  onNavigate,
  onLogout,
  children
}) {
  return (
    <div className="platform-shell">
      <aside className="platform-sidebar">
        <div className="platform-logo">
          <img src="/branding/logo-zeppelin.png" alt="Zeppelin" />
          <p>CI/CD Maturity</p>
        </div>

        <nav>
          {navItems.map((item) => (
            <button
              key={item.key}
              type="button"
              className={item.key === activePage ? "active" : ""}
              onClick={() => onNavigate(item.key)}
            >
              {item.label}
            </button>
          ))}
        </nav>

        <button className="logout-btn" type="button" onClick={onLogout}>
          Sign out
        </button>
      </aside>

      <section className="platform-main">
        <header className="platform-topbar">
          <div>
            <p>{organization}</p>
            <h1>{title}</h1>
            <small>{subtitle}</small>
          </div>
          <div className="user-box">
            <span>{userName}</span>
          </div>
        </header>

        <div className="platform-content">{children}</div>
      </section>
    </div>
  );
}
