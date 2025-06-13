import sys
import json

author_first_names: list[str] = []
author_last_names: list[str] = []
genre_names: list[str] = []
genre_colors: list[int] = []
locations: list[str] = []
publishers: list[str] = []
publish_years: list[int] = []

def read_genre(genre_str: str) -> tuple[str, int]:
    global genre_names
    global genre_colors

    genre_name: str = genre_str
    genre_id: int
    try:
        genre_id = genre_names.index(genre_name)
    except:
        genre_id = len(genre_names)
        genre_names.append(genre_name)
        genre_colors.append(0x00)

    return (
        genre_names[genre_id],
        genre_colors[genre_id]
    )

def read_authors(authors_str: str) -> list[tuple[str, str]]:
    global author_first_names
    global author_last_names

    authors_result: list[tuple[str, str]] = []

    authors_strs: list[str] = authors_str.split("-")
    for author_str in authors_strs:
        author_name: list[str] = author_str.split(" ")
        author_first_name: str = author_name[0]
        author_last_name: str = author_name[1]
        author_id: int
        try:
            author_id = author_first_names.index(author_first_name)
        except:
            author_id = len(author_first_names)
            author_first_names.append(author_first_name)
            author_last_names.append(author_last_name)

        authors_result.append((
            author_first_names[author_id],
            author_last_names[author_id]
        ))

    return authors_result

def csv_to_json(
    dstpath: str,
    srcfilepath: str
) -> None:
    global author_first_names
    global author_last_names
    global genre_names
    global genre_colors
    global locations
    global publishers
    global publish_years

    with open(srcfilepath, "r") as in_file:
        for line in in_file:
            stripped_line: str = line.strip()

            line_parts: list[str] = stripped_line.split(";")
            genre: tuple[str, int] = read_genre(line_parts[0])
            authors: list[tuple[str, str]] = read_authors(line_parts[2])

            # TODO Read location, publisher, publish year and book data

            print(line_parts[2])

if __name__ == "__main__":
    csv_to_json(
        dstpath = sys.argv[1],
        srcfilepath = sys.argv[2],
    )