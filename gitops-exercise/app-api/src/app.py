from flask import Flask, jsonify
import random

app = Flask(__name__)


@app.route('/stats')
def stats():
    return jsonify({
        "status": "online",
        "cpu_usage": random.randint(10, 80),
        "active_connections": random.randint(100, 500)
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
