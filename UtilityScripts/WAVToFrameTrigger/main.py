# This is a sample Python script.
import array, sys, wave
import json


# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.


def main() -> None:
    if len(sys.argv) != 2:
        print("Usage: python3 main.py [path]")
    process_wave_file(sys.argv[1])


def process_wave_file(filename: str) -> None:
    wav_file = wave.open(filename, 'rb')
    rate = wav_file.getframerate()
    frames = wav_file.readframes(wav_file.getnframes())
    frames_interpreted = [abs(x) if abs(x) > 1000 else 0 for x in array.array('h', frames)]
    avg = 0
    chunk_len = 0
    chunk_size = rate // 60
    in_beat = False
    data_file = open('out.json', 'w')
    beats = []
    for frame in frames_interpreted:
        avg += frame / chunk_size
        chunk_len += 1
        if chunk_len >= chunk_size:
            beat = 0
            if avg > 0.0 and not in_beat:
                in_beat = True
                beat = 1
            elif avg == 0.0:
                in_beat = False
            avg = 0
            chunk_len = 0
            beats.append(beat)

    print(len(beats))
    output = {
        'beats': beats,
    }
    data_file.write(json.dumps(output))

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
