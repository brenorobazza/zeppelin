/**
 * Utilitário para gerenciar os cabeçalhos de autenticação das chamadas de API.
 */
export function getAuthHeaders(existingHeaders = {}) {
  let headers = { ...existingHeaders };

  try {
    const storedUser = localStorage.getItem("zeppelin_user");
    if (storedUser) {
      const user = JSON.parse(storedUser);
      if (user.accessToken) {
        headers["Authorization"] = `Bearer ${user.accessToken}`;
      }
    }
  } catch (err) {
    console.warn("Failed to parse user session for auth token.");
  }

  return headers;
}
