local function xor(a, b)
    local result = 0
    local bit = 1

    print(a)
    while a > 0 or b > 0 do
        if (a % 2) ~= (b % 2) then
            result = result + bit
        end

        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bit = bit * 2
    end

    return result
end

local function fnv1a_hash(str)
    local offset_basis = 2166136261
    local prime = 16777619
    local hash = offset_basis

    for i = 1, #str do
        local byte = str:byte(i)
        hash = xor(hash, byte)
        hash = (hash * prime) % (2 ^ 32)
    end

    return string.format("0x%08x", hash)
end

local function fnv1_hash(str)
    local offset_basis = 2166136261
    local prime = 16777619
    local hash = offset_basis

    for i = 1, #str do
        local byte = str:byte(i)
        hash = (hash * prime) % (2 ^ 32)
        hash = xor(hash, byte)
    end

    return string.format("0x%08x", hash)
end

local function sip_hash(str)
end

local algorithms = {
    fnv1 = fnv1_hash,
    fnv1a = fnv1a_hash,
}

-- benchmark
local function benchmark(asset)
    print(string.rep("=", 30))
    print("Starting benchmark for asset: " .. asset)
    print(string.rep("=", 30))
    for name, algo in pairs(algorithms) do
        local start_time = os.clock()* 10000
        local res = algo(asset)
        local elapsed_time = (os.clock() * 10000) - start_time
        print(name, ":", string.format("%.2f ms\n", elapsed_time))
    end
end

benchmark("test")
benchmark("Component.lua")
benchmark("{name=Component.lua}")

