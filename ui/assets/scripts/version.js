footer_version_element = document.getElementById('version')

async function setVersion(_) {

  let response_json
  let footer_text

  try {
    const response = await fetch('http://localhost:3031/version?current=is.true')
    response_json = await response.json()
    footer_text = "Conectado: Mirante " + response_json["0"].tag
  } catch(e) {
    console.log(e)
    footer_text = 'Erro de conexão: "' + e + '" com resposta "' + response_json + '"'
  }

  footer_version_element.innerText = (footer_text)
}

window.addEventListener("load", setVersion)
