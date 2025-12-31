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

def test_search(token):
    url = f"{BASE_URL}/plant/list"
    headers = {
        "Authorization": f"Bearer {token}"
    }
    
    # Test 1: No filters
    print("\n--- Test 1: No filters ---")
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        data = response.json()
        print(f"Total plants: {data['total']}")
        print("Listing all plants and their growth stages:")
        existing_stages = set()
        for plant in data['rows']:
            stage = plant.get('growthStage')
            print(f"  - {plant['plantName']}: {stage}")
            if stage:
                existing_stages.add(stage)
    else:
        print(f"Failed to get list: {response.text}")
        existing_stages = set()

    # Test 2: Search by plant_name (snake_case)
    print("\n--- Test 2: Search by plant_name (snake_case) ---")
    params = {"plant_name": "熊童子"} # Assuming "熊童子" exists based on previous context
    response = requests.get(url, headers=headers, params=params)
    if response.status_code == 200:
        data = response.json()
        print(f"Found {data['total']} plants with name '熊童子'")
    else:
        print(f"Failed to search: {response.text}")

    # Test 4: Search by growth_stage
    if existing_stages:
        test_stage = list(existing_stages)[0]
        print(f"\n--- Test 4: Search by growth_stage ('{test_stage}') ---")
        params = {"growth_stage": test_stage} 
        response = requests.get(url, headers=headers, params=params)
        if response.status_code == 200:
            data = response.json()
            print(f"Found {data['total']} plants in '{test_stage}'")
            for plant in data['rows']:
                print(f"  - {plant['plantName']} ({plant.get('growthStage')})")
        else:
            print(f"Failed to search: {response.text}")
    else:
        print("\n--- Test 4: Skipped (No growth stages found in data) ---")

if __name__ == "__main__":
    print("Starting test script...")
    token = login()
    if token:
        test_search(token)
