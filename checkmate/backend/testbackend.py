import requests

# Provide API Gateway URL below
url = ''


# Test registration
def test_authRegister(name, username, password):
    payload = {
        "name": name,
        "username": username,
        "password": password
    }
    response = requests.post(
        f'{url}/register',
        json=payload
    )
    return response


# Test login
def test_authLogin(username, password):
    payload = {
        "username": username,
        "password": password
    }
    response = requests.post(
        f'{url}/login',
        json=payload
    )
    return response


# Test getting all items
def test_actionsGetItems(jwt):
    headers = {
        "Authorization": f'Bearer {jwt}'
    }
    response = requests.get(
        f'{url}/actions/getItems',
        headers=headers
    )
    return response


# Test for adding an item
def test_actionsAddItem(jwt, text):
    headers = {
        "Authorization": f'Bearer {jwt}'
    }
    payload = {
        'text': text
    }
    response = requests.post(
        f'{url}/actions/addItem',
        headers=headers,
        json=payload
    )
    return response


# Test for deleting an item
def test_actionsDeleteItem(jwt, itemId):
    headers = {
        "Authorization": f'Bearer {jwt}'
    }
    response = requests.delete(
        f'{url}/actions/deleteItem/{itemId}',
        headers=headers
    )
    return response
