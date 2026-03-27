const API_BASE = import.meta.env.VITE_API_BASE_URL || import.meta.env.VITE_API_URL || "";

function normalizeOrganizationName(value) {
  return (value || "")
    .trim()
    .replace(/\s+/g, " ")
    .toLocaleLowerCase();
}

async function parseResponse(response, fallbackMessage) {
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    const message =
      data.error || data.detail || data.message || `${fallbackMessage} (status ${response.status})`;
    throw new Error(message);
  }

  return data;
}

export async function loginWithEmail({ email, password }) {
  const response = await fetch(`${API_BASE}/auth/login-api/`, {
    method: "POST",
    credentials: "include",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ email, password })
  });

  return parseResponse(response, "Falha ao autenticar.");
}

export async function registerAccount(payload) {
  const response = await fetch(`${API_BASE}/auth/register/`, {
    method: "POST",
    credentials: "include",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  return parseResponse(response, "Falha ao criar conta.");
}

export async function searchOrganizations(query) {
  const response = await fetch(
    `${API_BASE}/api/organization/organization/?search=${encodeURIComponent(query)}&page_size=5`,
    {
      credentials: "include",
    }
  );

  const data = await parseResponse(response, "Falha ao buscar organizacoes.");
  const organizations = data.data || [];
  const uniqueOrganizations = [];
  const seenNames = new Set();

  organizations.forEach((organization) => {
    const normalizedName = normalizeOrganizationName(organization.name);
    if (!normalizedName || seenNames.has(normalizedName)) {
      return;
    }

    seenNames.add(normalizedName);
    uniqueOrganizations.push(organization);
  });

  return uniqueOrganizations;
}

export async function requestPasswordReset(email) {
  const response = await fetch(`${API_BASE}/auth/forgot-password/`, {
    method: "POST",
    credentials: "include",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ email })
  });

  return parseResponse(response, "Falha ao solicitar recuperacao de senha.");
}
