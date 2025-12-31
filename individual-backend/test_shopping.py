import requests
import json

BASE_URL = "http://127.0.0.1:9098"

def login():
    url = f"{BASE_URL}/login"
    data = {
        "username": "admin",
        "password": "admin123",
        "code": "",
        "uuid": ""
    }
    try:
        headers = {"Referer": "http://localhost:9098/docs"}
        response = requests.post(url, data=data, headers=headers)
        if response.status_code == 200:
            res_json = response.json()
            if "access_token" in res_json:
                print("Login successful")
                return res_json["access_token"]
            elif res_json.get("code") == 200:
                print("Login successful")
                return res_json["data"]["access_token"]
            else:
                print(f"Login failed: {res_json.get('msg')}")
        else:
            print(f"Login failed with status {response.status_code}")
    except Exception as e:
        print(f"Login error: {e}")
    return None

def test_shopping(token):
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    # 1. Add Shopping Item
    print("\n--- Test 1: Add Shopping Item ---")
    item_data = {
        "itemName": "Test Item",
        "category": "Test Category",
        "price": 100.50,
        "quantity": 2,
        "priority": "High",
        "status": "Pending",
        "platform": "Taobao",
        "notes": "This is a test item"
    }
    response = requests.post(f"{BASE_URL}/shopping", headers=headers, json=item_data)
    if response.status_code == 200:
        print("Add successful")
    else:
        print(f"Add failed: {response.text}")
        return

    # 2. List Shopping Items
    print("\n--- Test 2: List Shopping Items ---")
    response = requests.get(f"{BASE_URL}/shopping/list", headers=headers)
    item_id = None
    if response.status_code == 200:
        data = response.json()
        print(f"Response keys: {data.keys()}")
        if 'rows' in data:
            print(f"Total items: {data.get('total')}")
            for item in data['rows']:
                if item['itemName'] == "Test Item":
                    item_id = item['id']
                    print(f"Found created item: {item['itemName']} (ID: {item_id})")
                    print(f"Total Cost: {item['totalCost']}")
                    break
        elif 'data' in data and 'rows' in data['data']:
             print(f"Total items: {data['data']['total']}")
             for item in data['data']['rows']:
                if item['itemName'] == "Test Item":
                    item_id = item['id']
                    print(f"Found created item: {item['itemName']} (ID: {item_id})")
                    print(f"Total Cost: {item['totalCost']}")
                    break
    else:
        print(f"List failed: {response.text}")
        return

    if not item_id:
        print("Could not find the created item.")
        return

    # 3. Update Shopping Item
    print("\n--- Test 3: Update Shopping Item ---")
    update_data = {
        "id": item_id,
        "status": "Purchased",
        "notes": "Updated notes"
    }
    response = requests.put(f"{BASE_URL}/shopping", headers=headers, json=update_data)
    if response.status_code == 200:
        print("Update successful")
    else:
        print(f"Update failed: {response.text}")

    # 4. Get Detail
    print("\n--- Test 4: Get Shopping Detail ---")
    response = requests.get(f"{BASE_URL}/shopping/{item_id}", headers=headers)
    if response.status_code == 200:
        data = response.json()
        print(f"Detail status: {data['data']['status']}")
        print(f"Detail notes: {data['data']['notes']}")
    else:
        print(f"Get Detail failed: {response.text}")

    # 5. Delete Shopping Item
    print("\n--- Test 5: Delete Shopping Item ---")
    response = requests.delete(f"{BASE_URL}/shopping/{item_id}", headers=headers)
    if response.status_code == 200:
        print("Delete successful")
    else:
        print(f"Delete failed: {response.text}")

if __name__ == "__main__":
    print("Starting shopping test script...")
    token = login()
    if token:
        test_shopping(token)
