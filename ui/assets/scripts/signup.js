const form = document.getElementById('account_creation_form')

async function sign_up_handler(event) {
  event.preventDefault();

  const form_data = Object.fromEntries(new FormData(form));

  const response = await fetch('http://localhost:3031/rpc/signup', {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(form_data),
  })

  response_json = await response.json()

  credentials = {
    "email": response_json["user"].email,
    "token": response_json.token,
  }

  sessionStorage.setItem("mirante_credentials", JSON.stringify(credentials))
  let stored_credentials = JSON.parse(sessionStorage.getItem("mirante_credentials"))
  console.log("Stored Email: " + stored_credentials.email)
  console.log("Stored Token: " + stored_credentials.token)
}

form.addEventListener('submit', sign_up_handler)
