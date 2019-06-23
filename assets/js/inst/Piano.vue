<template>
  <g class="inst-piano" @mousedown="performing=true" :transform="pianoPos()">
    <defs>
      <linearGradient id="pianoWhiteKeyBg" x1="0.410156" y1="0.417969" x2="0.320313" y2="0.144531">
      <stop stop-color="#fff" offset="0"/>
      <stop stop-color="#b7b7b7" stop-opacity="0.996094" offset="1"/>
      </linearGradient>
      <linearGradient id="pianoBlackKeyGloss" x1="0.558594" y1="0.785156" x2="0.144531" y2="0">
      <stop stop-color="#666" offset="0"/>
      <stop stop-color="#fff" stop-opacity="0.996094" offset="1"/>
      </linearGradient>
    </defs>

    <g v-for="(white, index) in whites" :transform="whitePos(index)"
        @mousedown.prevent="play(white.note)" @mouseenter="play(white.note, true)"
        :class="{
          'white-key': true,
          'selected': performing && selectedNote === white.note,
          'last': lastNote === white.note
        }">
      <rect class="piano-key-bg" height="100" width="20" x="-0.333333"/>
    </g>

    <g v-for="(black, index) in blacks" :transform="blackPos(black.pos)"
        @mousedown.prevent="play(black.note)" @mouseenter="play(black.note, true)"
        :class="{
          'black-key': true,
          'selected': performing && selectedNote === black.note,
          'last': lastNote === black.note
        }">
      <rect class="piano-key-bg" fill="#000" stroke="#000" width="12" height="60"/>
      <rect fill="#666" stroke-width="0" x="11" y="0.333334" width="1" height="59" stroke="#000"/>
      <rect fill="url(#pianoBlackKeyGloss)" stroke-width="0" x="0.833333" y="56" width="10.5" height="3.666667" stroke="#000"/>
    </g>
  </g>
</template>

<script>
import Vue from "vue"

export default {
  data() { return {
    whites: [],
    blacks: [],
    selectedNote: -1,
    performing: false,
  } },
  props: {
    x: 0, y: 0,
    lastNote: 0,
  },
  methods: {
    pianoPos() {
      return `translate(${this.x},${this.y})`
    },
    whitePos(index) {
      return `translate(${index * 20},0)`
    },
    blackPos(index) {
      return `translate(${index * 20 + 4},0)`
    },
    play(note, dragging=false) {
      if (dragging && !this.performing) return
      this.selectedNote = note
      this.$emit('play-note', note+48)
    }
  },
  mounted() {
    function toNote(i) {
      return function(n) {
        return {
          pos: n.pos + 7 * i,
          note: n.note + 12 * i
        }
      }
    }

    for (let i = 0; i < 4; i++) {
      this.whites = this.whites.concat(
        [
          { pos: 0, note: 0 },
          { pos: 1, note: 2 },
          { pos: 2, note: 4 },
          { pos: 3, note: 5 },
          { pos: 4, note: 7 },
          { pos: 5, note: 9 },
          { pos: 6, note: 11 }
        ].map(toNote(i))
      )
      this.blacks = this.blacks.concat(
        [
          { pos: 0.5, note: 1 },
          { pos: 1.5, note: 3 },
          { pos: 3.5, note: 6 },
          { pos: 4.5, note: 8 },
          { pos: 5.5, note: 10 }
        ].map(toNote(i))
      )
    }

    window.addEventListener('mouseup', e => this.performing=false, false)
  }
}
</script>

<style lang="stylus">
g.inst-piano
  // rect.piano-key-bg
  //   transition: all .1s ease-out

  g.white-key rect.piano-key-bg
    fill: url(#pianoWhiteKeyBg)
    stroke: #000

  g.white-key.last rect.piano-key-bg
    fill: #fcc
  g.black-key.last rect.piano-key-bg
    fill: #400

  g.selected rect.piano-key-bg
    fill: red !important
</style>
