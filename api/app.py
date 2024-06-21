import os
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
    amount = req_data.get('amount', 0.0)
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
    }), 201

@app.route('/api/search', methods=['POST'])
def search_currency():
    req_data = request.get_json()
    print(req_data)
    search = req_data.get('search', '').strip()
    currency = req_data.get('currency', '').strip().lower()
    page = req_data.get('page', 1)
    size = req_data.get('size', 15)

    if not currency:
        return jsonify({
            'status': 'Missing currency parameter',
            'errorCode': 400,
        }), 400

    filtered_items = []
    total_riel = 0
    total_dollar = 0

    # Define the base query and order by ID descending
    query = Currency.query.order_by(Currency.id.desc())
    if search:
        query = query.filter(Currency.name.contains(search))

    # Determine the total number of items for the given query
    total_items = query.count()
    start_count = total_items - (page - 1) * size

    # Paginate based on the currency parameter
    if currency in ['all', 'ទាំងអស់']:
        pagination = query.paginate(page=page, per_page=size, error_out=False)
        items = pagination.items
        count = start_count
        for item in items:
            if item.riel is not None:
                item_data = {'count': count, 'id': str(item.id), 'name': item.name, 'amount': str(item.riel), 'currency': 'រៀល'}
                filtered_items.append(item_data)
                total_riel += item.riel
                count -= 1
            if item.dollar is not None:
                item_data = {'count': count, 'id': str(item.id), 'name': item.name, 'amount': f"{item.dollar:.2f}", 'currency': 'ដុល្លារ'}
                filtered_items.append(item_data)
                total_dollar += item.dollar
                count -= 1
    elif currency in ['riel', 'រៀល']:
        riel_query = query.filter(Currency.riel.isnot(None))
        total_items = riel_query.count()
        start_count = total_items - (page - 1) * size
        pagination = riel_query.paginate(page=page, per_page=size, error_out=False)
        items = pagination.items
        count = start_count
        for item in items:
            item_data = {'count': count, 'id': str(item.id), 'name': item.name, 'amount': str(item.riel), 'currency': 'រៀល'}
            filtered_items.append(item_data)
            total_riel += item.riel
            count -= 1
    elif currency in ['dollar', 'ដុល្លារ']:
        dollar_query = query.filter(Currency.dollar.isnot(None))
        total_items = dollar_query.count()
        start_count = total_items - (page - 1) * size
        pagination = dollar_query.paginate(page=page, per_page=size, error_out=False)
        items = pagination.items
        count = start_count
        for item in items:
            item_data = {'count': count, 'id': str(item.id), 'name': item.name, 'amount': f"{item.dollar:.2f}", 'currency': 'ដុល្លារ'}
            filtered_items.append(item_data)
            total_dollar += item.dollar
            count -= 1
    else:
        return jsonify({
            'status': 'Invalid currency parameter',
            'errorCode': 400,
        }), 400

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

def write_ip_to_dart_file(ip_address):
    dart_file_path = os.path.join('/Users/pwboth/Mobile App/kort_jomnorng_dai_app/lib', 'ip_address.dart')
    with open(dart_file_path, 'w') as file:
        file.write(f"const String kPcIpAddress = '{ip_address}';\n")

if __name__ == '__main__':
    local_ip = get_local_ip()
    write_ip_to_dart_file(local_ip)
    app.run(host=local_ip, port=5000, debug=True, use_reloader=True)