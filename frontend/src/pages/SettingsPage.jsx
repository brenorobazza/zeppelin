export function SettingsPage() {
  return (
    <>
      {/* Bloco de dados da organização.
          Nesta proposta ele funciona como uma tela corporativa simples de manutenção cadastral. */}
      <section className="panel">
        <h3>Organization Profile</h3>
        <div className="grid-3">
          <label>
            Organization Name
            <input defaultValue="Zeppelin Labs" />
          </label>
          <label>
            Industry
            <input defaultValue="Software & Technology" />
          </label>
          <label>
            Team Size
            <input defaultValue="140 engineers" />
          </label>
        </div>
      </section>

      {/* Bloco de dados do usuário atual.
          Como o foco do TCC não é administração de perfis, esta tela foi mantida propositalmente enxuta. */}
      <section className="panel">
        <h3>User Profile</h3>
        <div className="grid-3">
          <label>
            Full Name
            <input defaultValue="Alex Silva" />
          </label>
          <label>
            Email
            <input defaultValue="alex@zeppelinlabs.com" />
          </label>
          <label>
            Role
            <input defaultValue="Engineering Manager" />
          </label>
        </div>
        <div className="btn-row" style={{ marginTop: "1rem" }}>
          {/* Botões visuais para compor a experiência de edição.
              Hoje funcionam mais como referência de interface do que como fluxo completo. */}
          <button className="btn-secondary-ui" type="button">
            Cancel
          </button>
          <button className="btn-primary-ui" type="button">
            Save Changes
          </button>
        </div>
      </section>
    </>
  );
}
