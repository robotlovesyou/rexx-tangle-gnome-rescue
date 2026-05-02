import sys

from mido import MidiFile, tick2second, bpm2tempo
from json import dumps

def main():
    midifile = MidiFile('/Users/andrewsmith/Desktop/RexxMusic/Files/MelodyMidi.mid')
    tempo = bpm2tempo(100)
    ticks_per_beat = midifile.ticks_per_beat
    if midifile.type != 0:
        print("File is not type 0. Cannot process it")

    events = []

    ticks = 0
    ticks_at_last_beat = -sys.maxsize
    for msg in midifile.tracks[0]:
        ticks += msg.time
        if msg.type == 'note_on' and ticks - ticks_at_last_beat > ticks_per_beat/8:
            ticks_at_last_beat = ticks
            events.append(tick2second(ticks, ticks_per_beat, tempo))

    data = {'beats': events}
    with open('out.json', 'w') as outfile:
        outfile.write(dumps(data))


if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
