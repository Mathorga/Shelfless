

import 'package:shelfless/utils/strings/strings.dart';

/// Italian strings.
class ItStrings implements Strings {
  @override String get settings => "Impostazioni";
  @override String get privacyPolicyLabel => "Informativa privacy";
  @override String get licensesLabel => "Licenze";
  @override String get supportLabel => "Contatta il supporto";
  @override String get librariesTitle => "Biblioteche";
  @override String get othersTitle => "Altro";
  @override String get all => "Tutti";
  @override String get book => "libro";
  @override String get books => "libri";
  @override String get importLib => "Importa";
  @override String get newLib => "Nuova";
  @override String get addLibraryTitle => "Nuova biblioteca";
  @override String get deleteLibraryTitle => "Elimina Biblioteca";
  @override String get deleteLibraryContent => "Vuoi davvero eliminare";
  @override String get yes => "Sì";
  @override String get no => "No";
  @override String get ok => "OK";
  @override String get confirm => "Conferma";
  @override String get cancel => "Annulla";
  @override String get genericCannotDelete => "Impossibile cancellare";
  @override String get cannotDeleteAuthorContent => "Questo autore compare ancora in alcuni libri.\nCancellali o modificali e poi riprova";
  @override String get authorDeleted => "Autore eliminato";
  @override String get deleteAuthorTitle => "Elimina autore";
  @override String get deleteAuthorContent => "Vuoi davvero eliminare questo autore?\nL'operazione è irreversibile.";
  @override String get cannotDeleteGenreContent => "Questo genere compare ancora in alcuni libri.\nCancellali o modificali e poi riprova";
  @override String get genreDeleted => "Genere eliminato";
  @override String get deleteGenreTitle => "Elimina genere";
  @override String get deleteGenreContent => "Vuoi davvero eliminare questo genere?\nL'operazione è irreversibile.";
  @override String get cannotDeletePublisherContent => "Questo editore compare ancora in alcuni libri.\nCancellali o modificali e poi riprova";
  @override String get publisherDeleted => "Editore eliminato";
  @override String get deletePublisherTitle => "Elimina editore";
  @override String get deletePublisherContent => "Vuoi davvero eliminare questo editore?\nL'operazione è irreversibile.";
  @override String get authorInfo => "Scheda Autore";
  @override String get genreInfo => "Scheda Genere";
  @override String get publisherInfo => "Scheda Editore";
  @override String get locationInfo => "Scheda Posizione";
  @override String get bookInfo => "Scheda Libro";
  @override String get firstName => "Nome";
  @override String get lastName => "Cognome";
  @override String get outLabel => "PRESTATO";
  @override String get bookEdit => "Modifica";
  @override String get bookMoveTo => "Sposta in";
  @override String get bookMarkOutAction => "Imposta come assente";
  @override String get bookMarkInAction => "Imposta come rientrato";
  @override String get bookDeleteAction => "Elimina";
  @override String get bookDeleted => "Libro cancellato";
  @override String get deleteBookTitle => "Eliminazione";
  @override String get deleteBookContent => "Vuoi davvero eliminare questo libro?\nL'operazione è irreversibile.";
  @override String get bookInfoTitle => "Titolo";
  @override String get bookInfoCover => "Copertina";
  @override String get bookInfoNoImageSelected => "nessuna immagine selezionata";
  @override String get bookInfoLibrary => "Biblioteca";
  @override String get bookInfoAuthors => "Autori";
  @override String get bookInfoPublishDate => "Anno di pubblicazione";
  @override String get bookInfoGenres => "Generi";
  @override String get bookInfoPublisher => "Editore";
  @override String get bookInfoPublishers => "Editori";
  @override String get bookInfoLocation => "Posizione";
  @override String get insertTitle => "Inserisci";
  @override String get editTitle => "Modifica";
  @override String get authorTitle => "Autore";
  @override String get authorInfoFirstName => "Nome";
  @override String get authorInfoLastName => "Cognome";
  @override String get editDone => "Fine";
  @override String get bookTitle => "Libro";
  @override String get addOne => "Aggiungi";
  @override String get add => "Nuovo";
  @override String get authorAlreadyAdded => "Autore già aggiunto";
  @override String get genreAlreadyAdded=> "Genere già aggiunto";
  @override String get selectPublishYear => "Seleziona anno di pubblicazione";
  @override String get select => "Seleziona";
  @override String get publishers => "Editori";
  @override String get locations => "Posizioni";
  @override String get bookErrorNoTitleProvided => "Inserire un titolo";
  @override String get bookErrorNoAuthorProvided => "Inserire almeno un autore";
  @override String get bookErrorNoGenreProvided => "Inserire almeno un genere";
  @override String get genreTitle=> "Genere";
  @override String get genreInfoName=> "Nome";
  @override String get genreInfoColor => "Colore";
  @override String get genrePickColor => "Scegli un colore";
  @override String get libraryTitle => "Biblioteca";
  @override String get libraryInfoName => "Nome";
  @override String get locationTitle => "Posizione";
  @override String get locationInfoName => "Nome";
  @override String get publisherTitle => "Editore";
  @override String get publisherInfoName => "Nome";
  @override String get booksSectionTitle => "Libri";
  @override String get genresSectionTitle => "Generi";
  @override String get authorsSectionTitle => "Autori";
  @override String get publishersSectionTitle => "Editori";
  @override String get locationsSectionTitle => "Posizioni";
  @override String get shareLibrary => "Condividi";
  @override String get exportLibrary => "Esporta";
  @override String get updateLibrary => "Aggiorna";
  @override String get filtersTitle => "Filtri";
  @override String get filtersApply => "Applica";
  @override String get filtersCancel => "Annulla";
  @override String get filtersClear => "Cancella";
  @override String get filteredBooksTitle => "Libri filtrati";
  @override String get noLibrariesFound => "Nessuna biblioteca";
  @override String get noAuthorsFound => "Nessun autore trovato";
  @override String get noGenresFound => "Nessun genere trovato";
  @override String get noLocationsFound => "Nessuna posizione trovata";
  @override String get noPublishersFound => "Nessun editore trovato";
  @override String get noBooksFound => "Nessun libro trovato";
  @override String get search => "Cerca";
  @override String get genericInfo => "Info";
  @override String get genericWarning => "Attenzione";
  @override String get genericError => "Si è verificato un errore";
  @override String get unreleasedFeatureAlert => "Questa funzionalità sarà introdotta con un futuro aggiornamento.";
  @override String get coverDescription => "Considera la copertina come un'idea della copertina originale, non starci troppo a pensare e scegli una foto che ti piace, o che ti ricorda questo libro. L'immagine sarà comunque compressa.";
}