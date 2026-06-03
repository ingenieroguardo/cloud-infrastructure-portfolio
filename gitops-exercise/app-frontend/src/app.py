from flask import Flask, render_template
import requests
import os

app = Flask(__name__)
API_URL = os.environ.get('API_URL', 'http://app-api:5000/stats')


@app.route('/')
def index():
    try:
        response = requests.get(API_URL).json()
    except:
        response = {"status": "error", "cpu_usage": 0, "active_connections": 0}
    return render_template('index.html', data=response)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
