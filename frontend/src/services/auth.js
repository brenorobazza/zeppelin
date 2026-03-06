const API_BASE = import.meta.env.VITE_API_BASE_URL || "";

export async function loginWithEmail({ email, password }) {
  const response = await fetch(`${API_BASE}/auth/login-api/`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ email, password })
  });

  const data = await response.json().catch(() => ({}));
  if (!response.ok) {
    throw new Error(data.error || "Falha ao autenticar.");
  }

  return data;
}
