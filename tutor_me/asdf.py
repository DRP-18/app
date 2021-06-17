from requests import Session

url = "https://tutor-drp.herokuapp.com"
s = Session()

print(s.post(f"{url}/login", {"username": "Jayme"}))

r = s.post(f"{url}/getSessions", b"{\"message\":\"1\"}")

print(r.request.headers)
print(r.request.body)
print(r.status_code)