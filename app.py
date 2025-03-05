from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    """
    Home route that returns a welcome message.
    """
    return jsonify(message="devireddy-harshtha-reddy-tirupathi-hostel!")

if __name__ == '__main__':
    # Use environment variables or a config file for host and port
    app.run(host='0.0.0.0', port=8000)
