import csv
import json
import os
import re
import random
import argparse
import zipfile
import tempfile

def split_author(full_name):
    """Splits authors by delimiters and parses into (first, last) names."""
    # Split by common delimiters: " - ", " / ", ";", " e " (italian for 'and')
    parts = re.split(r'[-/;]| e ', full_name)
    results = []
    for p in parts:
        p = p.strip()
        if not p: continue
        name_parts = p.split()
        # Heuristic: Last word is surname, rest is first name
        first = " ".join(name_parts[:-1]) if len(name_parts) > 1 else ""
        last = name_parts[-1]
        results.append((first, last))
    return results

def get_random_color():
    """Generates a random 32-bit integer color (AARRGGBB format)."""
    # 0xFF000000 sets Alpha to 255 (fully opaque) | random RGB
    return 0xFF000000 | random.randint(0, 0xFFFFFF)

def convert_csv_to_muntlabets(input_path, output_dir):
    # Data Containers
    books = []
    authors = []
    genres = []
    publishers = []
    locations = []
    
    # Lookup maps (Name -> ID)
    author_map = {} 
    genre_map = {}  
    pub_map = {}    
    loc_map = {}    
    
    # Relationship lists
    b_auth_rel = []
    b_gen_rel = []

    print(f"Reading from: {input_path}")

    # Determine Output Filename
    # Extracts 'BIBLIOTECA' from 'path/to/BIBLIOTECA.csv' and adds .zip
    base_name = os.path.splitext(os.path.basename(input_path))[0]
    output_filename = f"{base_name}.slz"
    final_output_path = os.path.join(output_dir, output_filename)

    # Ensure output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    try:
        # Pre-read to handle potential metadata lines (like "BIBLIOTECA;;;")
        with open(input_path, 'r', encoding='utf-8-sig') as f:
            header = f.readline()
            
        with open(input_path, 'r', encoding='utf-8-sig') as f:
            # Logic to skip the first line if it's just the file title
            first_line = f.readline()
            if "TITOLO" not in first_line and "BIBLIOTECA" in first_line:
                pass # Skip this line, next is header
            else:
                f.seek(0) # Reset if the first line was actually valid data/header

            reader = csv.DictReader(f, delimiter=';')
            
            for idx, row in enumerate(reader, 1):
                if not row.get('TITOLO'): continue
                
                # 1. Location
                loc = row.get('LUOGO', '').strip() or "Unknown"
                if loc not in loc_map:
                    loc_id = len(locations) + 1
                    loc_map[loc] = loc_id
                    locations.append({"locations_id": loc_id, "locations_name": loc})
                else:
                    loc_id = loc_map[loc]
                
                # 2. Publisher
                pub = row.get('CASA EDITRICE', '').strip() or "Unknown"
                if pub not in pub_map:
                    pub_id = len(publishers) + 1
                    pub_map[pub] = pub_id
                    publishers.append({"publishers_id": pub_id, "publishers_name": pub})
                else:
                    pub_id = pub_map[pub]

                # 3. Book
                book_id = idx
                try:
                    year_val = row.get('ANNO', '0')
                    year = int(year_val) if year_val.isdigit() else 0
                except ValueError:
                    year = 0

                books.append({
                    "books_id": book_id,
                    "books_title": row['TITOLO'].strip(),
                    "books_publish_year": year,
                    "books_publisher_id": pub_id,
                    "books_location_id": loc_id,
                    "books_library_id": 1,
                    "books_out": 0, "books_edition": 1, "books_notes": ""
                })

                # 4. Authors
                for first, last in split_author(row.get('AUTORE', '')):
                    key = f"{first}|{last}"
                    if key not in author_map:
                        a_id = len(authors) + 1
                        author_map[key] = a_id
                        authors.append({
                            "authors_id": a_id, 
                            "authors_first_name": first, 
                            "authors_last_name": last,
                            "authors_homeland": ""
                        })
                    else:
                        a_id = author_map[key]
                    b_auth_rel.append({"book_author_rel_book_id": book_id, "book_author_rel_author_id": a_id})

                # 5. Genres (Randomized Colors)
                raw_genre = row.get('GENERE', '')
                if raw_genre:
                    for g in raw_genre.split('-'):
                        g = g.strip()
                        if not g: continue
                        if g not in genre_map:
                            g_id = len(genres) + 1
                            genre_map[g] = g_id
                            genres.append({
                                "genres_id": g_id, 
                                "genres_name": g, 
                                "genres_color": get_random_color()
                            })
                        else:
                            g_id = genre_map[g]
                        b_gen_rel.append({"book_genre_rel_book_id": book_id, "book_genre_rel_genre_id": g_id})

        # Prepare JSON data
        db_files = {
            "books.json": books, "authors.json": authors, "genres.json": genres,
            "publishers.json": publishers, "locations.json": locations,
            "book_author_rel.json": b_auth_rel, "book_genre_rel.json": b_gen_rel,
            "db_info.json": {"version": 2}, 
            "libraries.json": [{"libraries_id": 1, "libraries_name": base_name}]
        }

        # Write to Zip
        print(f"Writing to: {final_output_path}")
        with zipfile.ZipFile(final_output_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            with tempfile.TemporaryDirectory() as temp_dir:
                for filename, data in db_files.items():
                    temp_file_path = os.path.join(temp_dir, filename)
                    with open(temp_file_path, 'w', encoding='utf-8') as json_file:
                        json.dump(data, json_file, indent=4)
                    zipf.write(temp_file_path, arcname=filename)
        
        print("Conversion complete!")

    except FileNotFoundError:
        print(f"Error: The file '{input_path}' was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert Library CSV to Muntlabets JSON Zip")
    parser.add_argument("input_file", help="Path to the source CSV file")
    parser.add_argument("output_dir", help="Directory where the output file will be saved")
    
    args = parser.parse_args()
    
    convert_csv_to_muntlabets(args.input_file, args.output_dir)