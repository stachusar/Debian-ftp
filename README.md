# Instrukcja Użycia dla [Skryptu Mirroringu Debian](https://github.com/stachusar/Debian-ftp/blob/main/debian-ftp.sh)

## Opis
Ten skrypt Bash jest przeznaczony do tworzenia lokalnego lustra repozytorium Debian przy użyciu `rsync`. Skrypt sprawdza dostępność serwera lustrzanego, synchronizuje pliki, zarządza katalogami i loguje działania.

## Procedura Działania Skryptu

1. **Sprawdzenie Dostępności Serwera Lustrzanego (`check_mirror`)**:
    - Skrypt sprawdza, czy serwer rsync jest dostępny. Jeśli nie, skrypt zakończy działanie z błędem.

2. **Tworzenie Katalogu, jeśli nie istnieje (`BASEDIR`)**:
    - Sprawdza, czy istnieje katalog docelowy. Jeśli nie, próbuje go stworzyć.

3. **Pierwsza Faza Synchronizacji**:
    - Wykonuje `rsync` z opcjami wykluczenia pewnych plików, aby zsynchronizować pozostałe pliki z serwera źródłowego do katalogu lokalnego.

4. **Druga Faza Synchronizacji**:
    - Dodatkowe użycie `rsync` z opcjami usuwania, aby upewnić się, że lustrzane odbicie jest aktualne z źródłem.

5. **Zmiana Właściciela Katalogu**:
    - Skrypt zmienia właściciela katalogu na użytkownika `ubuntu`.

6. **Rejestrowanie Działania**:
    - Daty synchronizacji są zapisywane w katalogu projektu.

## Konfiguracja
- `RSYNCSOURCE`: URL źródła rsync.
- `BASEDIR`: Lokalna ścieżka katalogu, gdzie pliki będą przechowywane.

## Logowanie
- Informacje o błędach są zapisywane w `debianmirror-error.log`.
- Szczegóły operacji synchronizacji są zapisywane w `debianmirror.log`.

## Ważne Komendy
- `rsync -av --exclude`: Synchronizacja plików z wykluczeniem określonych wzorców.
- `sudo mkdir -p`: Tworzenie katalogów z potrzebnymi uprawnieniami.
- `sudo chown -R`: Zmiana właściciela katalogów i plików na określonego użytkownika.

## Uwagi
- Upewnij się, że masz odpowiednie uprawnienia do wykonania `sudo`.
- Regularnie sprawdzaj logi, aby monitorować stan i ewentualne błędy.
