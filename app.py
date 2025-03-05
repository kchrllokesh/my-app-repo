from flask import Flask # type: ignore # Import the Flask class from the flask module

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, World!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)