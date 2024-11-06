const form = document.getElementById('login_form')
const dialog = document.getElementById('user_dialog')

async function login_handler(event) {
  event.preventDefault();
  dialog.innerText = ''

  const form_data = Object.fromEntries(new FormData(form));

  const response = await fetch('http://localhost:3031/rpc/login', {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(form_data),
  })

  response_json = await response.json()
  console.log(response_json)

  let credentials

  if (response_json.code == '28P01') {
    dialog.innerText = 'Senha incorreta'
    return
  } else {
    credentials = {
      "email": form_data.email,
      "token": response_json.token,
    }
    dialog.innerText = 'Login realizado'
  }

  sessionStorage.setItem("mirante_credentials", JSON.stringify(credentials))
  let stored_credentials = JSON.parse(sessionStorage.getItem("mirante_credentials"))
  console.log("Stored Email: " + stored_credentials.email)
  console.log("Stored Token: " + stored_credentials.token)
}

form.addEventListener('submit', login_handler)
