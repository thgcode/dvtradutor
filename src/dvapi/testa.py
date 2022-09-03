import requests
ender = "http://127.0.0.1:8080"
requests.post(f"{ender}/tela", json={"mensagem": "Programa de teste", "falando": False})

requests.post(f"{ender}/fala", json={"mensagem": "Ola mundo!"})
for i in range(10):
    requests.post(f"{ender}/bip")
    requests.post(f"{ender}/clek")
while True:
    m = requests.get(f"{ender}/linha", json={"falando": True})
    r = m.json()["resultado"]

    requests.post(f"{ender}/tela", json={"mensagem": f"Voce escreveu {r}", "falando": True, "nova_linha": False})
    requests.post(f"{ender}/tela", json={"mensagem": ".", "nova_linha": False, "falando": False})

    if r == "sair":
        break

requests.post(f"{ender}/tela", json={"mensagem": "Fim do programa", "nova_linha": True, "falando": True})
