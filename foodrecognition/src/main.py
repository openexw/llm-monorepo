from shared.this import return_one  # 这样写是对的
from shared.tools.google_search import search

def main():
    print("Hello World：", return_one())
    print("Hello from foodrecognition!")
    print(search("hello world"))


if __name__ == "__main__":
    main()
