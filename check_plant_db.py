import requests
import json

BASE_URL = "http://localhost:9098"

def test_list_plants():
    print("Testing List Plants...")
    response = requests.get(f"{BASE_URL}/plant/list?page_num=1&page_size=10")
    if response.status_code == 200:
        try:
            data = response.json()
            print(f"Total: {data['total']}")
            for row in data['rows']:
                print(f"ID: {row.get('id')}, Name: {row.get('plantName')}, CoverImage: {row.get('coverImage')}")
        except Exception as e:
            print(f"JSON Error: {e}")
            print(f"Response Text: {response.text}")
    else:
        print(f"Failed to list plants: {response.status_code}")
        print(f"Response Text: {response.text}")

if __name__ == "__main__":
    test_list_plants()
