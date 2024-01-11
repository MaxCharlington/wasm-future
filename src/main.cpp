#include <filesystem>
#include <fstream>
#include <cstdio>

#include <interp.hpp>

bool file_exists(const char* name) {
    if (FILE *file = fopen(name, "r")) {
        fclose(file);
        return true;
    } else {
        return false;
    }
}

int main(int argc, char** argv) {
    if (argc != 2) {
        puts("Wrong args. Provide file name of a wasm file");
        return 1;
    }

    if (not file_exists(argv[1])) {
        puts("File does not exist: ");
        puts(argv[1]);
        return 1;
    }
    std::filesystem::path wasm_file_path = argv[1];

    std::ifstream wasm_file(wasm_file_path, std::ios_base::binary);

    runtime rtm{std::ifstream(wasm_file_path, std::ios_base::binary)};
    return rtm.run();
}