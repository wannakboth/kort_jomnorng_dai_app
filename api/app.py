import netifaces

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configure the SQLite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///currency.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define the Currency model
class Currency(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    riel = db.Column(db.Integer, nullable=True)
    dollar = db.Column(db.Float, nullable=True)

    def __repr__(self):
        return f'<Currency {self.name}>'

# Create the database and the table
with app.app_context():
    db.create_all()

@app.route('/api/currency', methods=['POST'])
def create_currency():
    req_data = request.get_json()
    name = req_data.get('name', '').strip()
    amount = req_data.get('amount', 0)
    currency = req_data.get('currency', '').strip().lower()

    if not name:
        return jsonify({
            'status': 'Name is required',
            'errorCode': 400,
        }), 400

    if currency not in ['dollar', 'riel', 'ដុល្លារ', 'រៀល']:
        return jsonify({
            'status': 'Invalid currency',
            'errorCode': 400,
        }), 400

    if currency in ['dollar', 'ដុល្លារ']:
        new_currency = Currency(name=name, riel=None, dollar=amount)
    elif currency in ['riel', 'រៀល']:
        new_currency = Currency(name=name, riel=amount, dollar=None)

    db.session.add(new_currency)
    db.session.commit()

    return jsonify({
        'status': 'success',
        'errorCode': 201,
        'data': {
            'id': str(new_currency.id),
            'name': new_currency.name,
            'amount': str(amount),
            'currency': 'dollar' if new_currency.dollar else 'riel'
        }
    }), 201

@app.route('/api/search', methods=['POST'])
def search_currency():
    req_data = request.get_json()
    search = req_data.get('search', '').strip()
    currency = req_data.get('currency', '').strip().lower()
    page = req_data.get('page', 1)
    size = req_data.get('size', 10)

    if not currency:
        return jsonify({
            'status': 'Missing currency parameter',
            'errorCode': 400,
        }), 400

    filtered_items = []
    total_riel = 0
    total_dollar = 0

    query = Currency.query
    if search:
        query = query.filter(Currency.name.contains(search))

    items = query.all()
    
    pagination = query.paginate(page=page, per_page=size, error_out=False)
    items = pagination.items

    for item in items:
        item_data = {'id': str(item.id), 'name': item.name}
        if currency in ['all', 'ទាំងអស់']:
            if item.riel:
                item_data['amount'] = str(item.riel)
                item_data['currency'] = 'រៀល'
                total_riel += item.riel
                filtered_items.append(item_data)
            if item.dollar:
                item_data['amount'] = f"{item.dollar:.2f}"
                item_data['currency'] = 'ដុល្លារ'
                total_dollar += item.dollar
                filtered_items.append(item_data)
        elif currency in ['riel', 'រៀល'] and item.riel:
            item_data['amount'] = str(item.riel)
            item_data['currency'] = 'រៀល'
            filtered_items.append(item_data)
            total_riel += item.riel
        elif currency in ['dollar', 'ដុល្លារ'] and item.dollar:
            item_data['amount'] = f"{item.dollar:.2f}"
            item_data['currency'] = 'ដុល្លារ'
            filtered_items.append(item_data)
            total_dollar += item.dollar

    if not filtered_items:
        return jsonify({
            'status': 'No items found matching the criteria',
            'errorCode': 404,
        }), 404

    return jsonify({
        'status': 'success',
        'errorCode': 200,
        'data': {
            'totalRiel': str(total_riel),
            'totalDollar': f"{total_dollar:.2f}",
            'items': filtered_items
        }
    }), 200

@app.errorhandler(400)
def bad_request(error):
    return jsonify({
        'status': 'Bad Request',
        'errorCode': 400
    }), 400

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'status': 'Not Found',
        'errorCode': 404
    }), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        'status': 'Internal Server Error',
        'errorCode': 500
    }), 500
    
def get_local_ip():
    # Define common interface names for Ethernet and Wi-Fi on macOS
    interface_names = ['en0', 'en1']  # Typically 'en0' for Wi-Fi and 'en1' for Ethernet
    for interface in interface_names:
        try:
            addresses = netifaces.ifaddresses(interface)
            if netifaces.AF_INET in addresses:
                # Return the first found IP address
                ip = addresses[netifaces.AF_INET][0]['addr']
                return ip
        except (KeyError, ValueError):
            continue
    return '127.0.0.1'  # Default to localhost if no IP found

if __name__ == '__main__':
    local_ip = get_local_ip()
    app.run(host=local_ip, port=5000, debug=True, use_reloader=True)