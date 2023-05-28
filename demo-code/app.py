from flask import Flask, request, jsonify
import mysql.connector
from datetime import timedelta



app = Flask(__name__)

# Configurazione del database
config = {
    'host' : 'localhost',
    'user' : 'utente',
    'password' : 'password',
    'database' : 'PrenotazioneAuleUniversitarie'
}


@app.route('/sp/AuleDisponibili', methods=['POST'])
def aule_disponibili():
    nomeUniversita = request.json['nomeUniversita']
    capacita = request.json['capacita']
    data = request.json['data']
    oraInizio = request.json['oraInizio']
    oraFine = request.json['oraFine']

    try:

        db = mysql.connector.connect(
            host=config['host'],
            user=config['user'],
            password=config['password'],
            database=config['database']
        )
        db.start_transaction()
        cursor = db.cursor()
        cursor.callproc('AuleDisponibili', [nomeUniversita, capacita, data, oraInizio, oraFine])
        response = []
        for result in cursor.stored_results():
            fetched= result.fetchall()
            for tupla in fetched:
                aula ={
                    'id_aula': tupla[0],
                    'nome' : tupla[1],
                    'capacità' : tupla[2],
                    'id_edificio' : tupla[3]
                }
                response.append(aula)
        db.commit()
        cursor.close()
        db.close()

        return jsonify(response)

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/sp/ElencoPrenotazioniAula', methods=['POST'])
def elenco_prenotazioni():
    data_inizio = request.json['dataInizio']
    data_fine = request.json['dataFine']
    aula_id = request.json['aulaID']

    try:
        db = mysql.connector.connect(
            host=config['host'],
            user=config['user'],
            password=config['password'],
            database=config['database']
        )
        db.start_transaction()
        cursor = db.cursor()

        cursor.callproc('ElencoPrenotazioniAula', [data_inizio, data_fine, aula_id])

        response = []
        for result in cursor.stored_results():
            fetched= result.fetchall()
            for row in fetched:
                prenotazione = {
                'id_prenotazione': row[0],
                'id_aula': row[1],
                'data': row[2],
                'ora_inizio': serialize_timedelta(row[3]),
                'ora_fine': serialize_timedelta(row[4]),
                'descrizione': row[5],
                'id_utente' : row[6],
                'id_corso' : row[7]
            }
                response.append(prenotazione)
        db.commit()
        cursor.close()
        db.close()

        return jsonify(response)

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/sp/ElencoPrenotazioniUtente', methods=['POST'])
def elenco_prenotazioni_utente():
    data_inizio = request.json['dataInizio']
    data_fine = request.json['dataFine']
    utente_id = request.json['utenteID']

    try:
        db = mysql.connector.connect(
            host=config['host'],
            user=config['user'],
            password=config['password'],
            database=config['database']
        )
        db.start_transaction()
        cursor = db.cursor()

        cursor.callproc('ElencoPrenotazioniUtente', [data_inizio, data_fine, utente_id])

        response = []
        for result in cursor.stored_results():
            fetched= result.fetchall()
            for row in fetched:
                prenotazione = {
                'id_prenotazione': row[0],
                'id_aula': row[1],
                'data': row[2],
                'ora_inizio': serialize_timedelta(row[3]),
                'ora_fine': serialize_timedelta(row[4]),
                'descrizione': row[5],
                'id_utente' : row[6],
                'id_corso' : row[7]
            }
                response.append(prenotazione)

        
        db.commit()
        cursor.close()
        db.close()
       

        return jsonify(response)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/sp/AnnullaPrenotazione', methods=['POST'])
def annulla_prenotazione():
    prenotazione_id = int(request.json['prenotazioneID'])

    try:
        db = mysql.connector.connect(
            host=config['host'],
            user=config['user'],
            password=config['password'],
            database=config['database']
        )        
        db.start_transaction()

        cursor = db.cursor()

        cursor.callproc('AnnullaPrenotazione', [prenotazione_id])
        response = []
        for result in cursor.stored_results():
            fetched= result.fetchall()
            for row in fetched:
                messaggio = {"messaggio": row[0]}
                response.append(messaggio)


        db.commit()
        cursor.close()
        db.close()

        return jsonify(response)

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/sp/PrenotaAula', methods=['POST'])
def prenota_aula():
    aula_id = request.json['aulaID']
    data = request.json['data']
    ora_inizio = request.json['oraInizio']
    ora_fine = request.json['oraFine']
    descr = request.json['descr']
    corso_id = request.json['corsoID']
    utente_id = request.json['utenteID']

    try:
        db = mysql.connector.connect(
            host=config['host'],
            user=config['user'],
            password=config['password'],
            database=config['database']
        )
        db.start_transaction()

        cursor = db.cursor()

        cursor.callproc('PrenotaAula', [aula_id, data, ora_inizio, ora_fine, descr, corso_id, utente_id])

        
        response = []
        for result in cursor.stored_results():
            fetched= result.fetchall()
            for row in fetched:
                messaggio = {"messaggio": row[0]}
                response.append(messaggio)


        db.commit()
        cursor.close()
        db.close()

        return jsonify(response)

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/v/<nome_vista>', methods=['GET'])
def elenco_vista(nome_vista):
    try:
        VISTE_VALIDE = ['ElencoPrenotazioni', 'ElencoAule', 'ElencoEdifici', 'ElencoUniversità', 'ElencoDocenti', 'ElencoNonDocenti', 'ElencoCorsi', 'ElencoDipendenti']
        if nome_vista not in VISTE_VALIDE:
            raise ValueError(f"La vista '{nome_vista}' non è valida.")
        db = mysql.connector.connect(
            host=config['host'],
            user=config['user'],
            password=config['password'],
            database=config['database']
        )
        db.start_transaction()
        cursor = db.cursor()

        cursor.execute(f"SELECT * FROM {nome_vista}")

        results = cursor.fetchall()

        response = []
        for row in results:
            row_dict = {}
            for i, column_name in enumerate(cursor.description):
                row_dict[column_name[0]] = row[i]
                if isinstance(row_dict[column_name[0]], timedelta):
                    serialized_time = serialize_timedelta(row_dict[column_name[0]])
                    row_dict[column_name[0]]=serialized_time
            response.append(row_dict)

        db.commit()
        cursor.close()
        db.close()

        return jsonify(response)

    except ValueError as e:
        return jsonify({'error': str(e)}), 400

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
def serialize_timedelta(timedelta_obj):
    total_seconds = int(timedelta_obj.total_seconds())
    hours = total_seconds // 3600
    minutes = (total_seconds % 3600) // 60
    seconds = total_seconds % 60
    return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)