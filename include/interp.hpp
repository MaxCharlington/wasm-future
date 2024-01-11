#pragma once

#include <cassert>
#include <cstdio>
#include <ranges>
#include <algorithm>
#include <vector>
#include <fstream>
#include <cstring>
#include <cstddef>

#include <sys/mman.h>
#include <sys/stat.h> /* For mode constants */
#include <signal.h>

// static constexpr std::uint8_t wasm[] = {
//     0x00, 0x61, 0x73, 0x6d,
//     0x01, 0x00, 0x00, 0x00,
//     0x01, 0x05, 0x01, 0x60,
//     0x00, 0x01, 0x7f, 0x03,
//     0x02, 0x01, 0x00, 0x07,
//     0x08, 0x01, 0x04, 0x6d,
//     0x61, 0x69, 0x6e, 0x00,
//     0x00, 0x0a, 0x07, 0x01,
//     0x05, 0x00, 0x41, 0x2a,
//     0x0f, 0x0b
// };

// static_assert(wasm[0] == '\0');
// static_assert(wasm[1] == 'a');
// static_assert(wasm[2] == 's');
// static_assert(wasm[3] == 'm');

int f()
{
	for (int i = 0; i <= 10; i++)
	{
		if (i % 2 == 0) i++;
	}
	return 55;
}


class runtime
{
public:
    runtime(std::ifstream&& file) :
        wasm_file{std::move(file)},
        size{4},  // some size according to the size of wasm module
        instr_base_ptr{(int8_t*)mmap(NULL, size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0)}
    {
        if (instr_base_ptr == nullptr)
        {
            throw std::runtime_error{"mmap fail"};
        }
    }

    ~runtime() noexcept
    {
        munmap(instr_base_ptr, size);
    }

    int run() {
        // uint32_t wasm_version = *reinterpret_cast<const uint32_t*>(&exe[4]);
        // printf("%u", wasm_version);
        // constexpr uint32_t first_section_offset = 8;
        // const auto sections = exe | std::ranges::views::drop(first_section_offset);
        // for (auto byte_it = std::begin(sections); byte_it < std::end(sections);)
        // {
        //     std::int8_t section_id = *byte_it;
        //     byte_it++;
        // }
        start_interp_thread();
        return execute(&f);
    }

private:
    void start_interp_thread()
    {
        // static constexpr std::uint8_t code[] = {
        //     // 0x55,                                     // push   %rbp
        //     // 0x48, 0x89, 0xe5,                         // mov    %rsp,%rbp
        //     // 0xc7, 0x45, 0xfc, 0x00, 0x00, 0x00, 0x00, // movl   $0x0,-0x4(%rbp)
        //     // 0xeb, 0x12,                               // jmp    23 <main+0x23>
        //     // 0x8b, 0x45, 0xfc,                         // mov    -0x4(%rbp),%eax
        //     // 0x83, 0xe0, 0x01,                         // and    $0x1,%eax
        //     // 0x85, 0xc0,                               // test   %eax,%eax
        //     // 0x75, 0x04,                               // jne    1f <main+0x1f>
        //     // 0x83, 0x45, 0xfc, 0x01,                   // addl   $0x1,-0x4(%rbp)
        //     // 0x83, 0x45, 0xfc, 0x01,                   // addl   $0x1,-0x4(%rbp)
        //     // 0x83, 0x7d, 0xfc, 0x0a,                   // cmpl   $0xa,-0x4(%rbp)
        //     // 0x7e, 0xe8,                               // jle    11 <main+0x11>
        //     // 0xb8, 0x37, 0x00, 0x00, 0x00,             // mov    $0x37,%eax
        //     // 0x5d,                                     // pop    %rbp
        //     // 0xc3                                      // ret

        //     // 0x52, 0x80, 0x06, 0xe0,        //mov     w0, #0x37                       // #55
        //     // 0xd6, 0x5f, 0x03, 0xc0         //ret

        //     0x20, 0x37,
        //     0x47, 0x70
        // };
        std::memcpy(instr_base_ptr, (void*)&f, 4);
    }

    int execute(int(*func)()) noexcept
    {
        int8_t* ptr = (int8_t*)instr_base_ptr;
        int8_t* ptr2 = (int8_t*)func;
        // std::printf("%04x %04x %04x %04x ", ptr[0], ptr[1], ptr[2], ptr[3]);
        // std::printf("%04x %04x %04x %04x", ptr2[0], ptr2[1], ptr2[2], ptr2[3]);
        assert(ptr[0] == ptr2[0]);
        assert(ptr[1] == ptr2[1]);
        assert(ptr[2] == ptr2[2]);
        assert(ptr[3] == ptr2[3]);
        return ((int(*)(void))instr_base_ptr)();
        // return func();
    }

    std::ifstream wasm_file;

    std::size_t size;
    std::int8_t* instr_base_ptr;

    // Some runtime state data...
};
