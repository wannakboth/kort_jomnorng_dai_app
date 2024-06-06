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
    riel = req_data.get('riel', 0)
    dollar = req_data.get('dollar', 0.0)

    if not name:
        return jsonify({
            'status': 'Name is required',
            'errorCode': 400,
        }), 400

    new_currency = Currency(name=name, riel=riel, dollar=dollar)
    db.session.add(new_currency)
    db.session.commit()

    return jsonify({
        'status': 'success',
        'errorCode': 201,
        'data': {
            'id': str(new_currency.id),
            'name': new_currency.name,
            'riel': str(new_currency.riel) if new_currency.riel else "",
            'dollar': f"{new_currency.dollar:.2f}" if new_currency.dollar else ""
        }
    }), 201

@app.route('/api/search', methods=['POST'])
def search_currency():
    req_data = request.get_json()
    search = req_data.get('search', '').strip()
    currency = req_data.get('currency', '').lower()

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

    for item in items:
        item_data = {'id': str(item.id), 'name': item.name}
        if currency == 'all':
            if item.riel:
                item_data['riel'] = str(item.riel)
                total_riel += item.riel
            if item.dollar:
                item_data['dollar'] = f"{item.dollar:.2f}"
                total_dollar += item.dollar
            if 'riel' in item_data or 'dollar' in item_data:
                filtered_items.append(item_data)
        elif currency == 'riel' and item.riel:
            item_data['riel'] = str(item.riel)
            filtered_items.append(item_data)
            total_riel += item.riel
        elif currency == 'dollar' and item.dollar:
            item_data['dollar'] = f"{item.dollar:.2f}"
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

if __name__ == '__main__':
    app.run(debug=True)
