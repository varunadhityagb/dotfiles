#include "lib.hpp"
#include <chrono>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <thread>

int main() {
  init();

  const std::string outFile = "/tmp/qs_current_lyric";

  for (;;) {
    auto d = getCurrentLine();

    // Use C-style file IO for guaranteed atomic write
    FILE *f = fopen(outFile.c_str(), "w");
    if (f) {
      if (d.has_value()) {
        auto [line, pos, dur] = d.value();
        std::cerr << "Writing: " << line << std::endl;
        fputs(line.c_str(), f);
        fflush(f);
      } else {
        std::cerr << "Not playing" << std::endl;
      }
      fclose(f);
    } else {
      std::cerr << "Failed to open: " << outFile << std::endl;
    }

    using namespace std::chrono_literals;
    std::this_thread::sleep_for(1s);
  }
  return 0;
}
