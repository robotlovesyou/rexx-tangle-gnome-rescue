from mido import MidiFile, tick2second, bpm2tempo
from json import dumps

def main():
    midifile = MidiFile('/Users/andrewsmith/rexx-tangle-gnome-rescue/UtilityScripts/MidiAnalyser/data/asknot/asknotclaps.mid')
    tempo = bpm2tempo(135)
    ticks_per_beat = midifile.ticks_per_beat
    if midifile.type != 0:
        print("File is not type 0. Cannot process it")

    events = []

    ticks = 0
    for msg in midifile.tracks[0]:
        ticks += msg.time
        if msg.type == 'note_on':
            events.append(tick2second(ticks, ticks_per_beat, tempo))

    data = {'beats': events}
    with open('out.json', 'w') as outfile:
        outfile.write(dumps(data))


if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
