<template>
  <g class="inst-piano" :transform="position.getTransform()">
    <defs>
      <linearGradient id="pianoWhiteKeyBg" x1="0.410156" y1="0.417969" x2="0.320313" y2="0.144531">
        <stop stop-color="#fff" offset="0"/>
        <stop stop-color="#b7b7b7" stop-opacity="0.996094" offset="1"/>
      </linearGradient>
      <linearGradient id="pianoBlackKeyGloss" x1="0.558594" y1="0.785156" x2="0.144531" y2="0">
        <stop stop-color="#666" offset="0"/>
        <stop stop-color="#fff" stop-opacity="0.996094" offset="1"/>
      </linearGradient>
      <linearGradient id="pianoMoverBg" x1="0" y1="0" x2="0" y2="1">
        <stop stop-color="#777" offset="0"/>
        <stop stop-color="#444" offset="0.1"/>
        <stop stop-color="#333" offset="1"/>
      </linearGradient>
    </defs>

    <g class="piano-mover" @mousedown="beginMoving">
      <rect x="0" y="0" width="560" height="20" fill="url(#pianoMoverBg)"/>
      <line x1="4" y1="5" x2="556" y2="5" stroke="#777777cc" stroke-width="1"/>
      <line x1="4" y1="9" x2="556" y2="9" stroke="#777777cc" stroke-width="1"/>
      <line x1="4" y1="13" x2="556" y2="13" stroke="#777777cc" stroke-width="1"/>
    </g>

    <g class="piano-keyboard" @mousedown.prevent="performing=true" transform="translate(0,20)">
      <g v-for="(white, index) in whites" :transform="whitePos(index)"
          @mousedown.prevent="play(white.note)" @mouseenter="play(white.note, true)"
          @touchstart.prevent="play(white.note)" @touchenter="play(white.note, true)"
          :class="{
            'white-key': true,
            'selected': performing && selectedNote === white.note,
            'last': lastNote === white.note
          }">
        <rect class="piano-key-bg" :height="height-20" width="20" x="-0.33333"/>

        <text v-if="index>=7 && index<=16" x="10" :y="height-24" fill="#666" text-anchor="middle">{{ 'ASDFGHJKL'[index-7] }}</text>
      </g>

      <g v-for="(black, index) in blacks" :transform="blackPos(black.pos)"
          @mousedown.prevent="play(black.note)" @mouseenter="play(black.note, true)"
          @touchstart.prevent="play(black.note)" @touchenter="play(black.note, true)"
          :class="{
            'black-key': true,
            'selected': performing && selectedNote === black.note,
            'last': lastNote === black.note
          }">
        <rect class="piano-key-bg" fill="#111" stroke="#111" width="12" height="60"/>
        <rect fill="#666" stroke-width="0" x="11" y="0.333334" width="1" height="59" stroke="#111"/>
        <rect fill="url(#pianoBlackKeyGloss)" stroke-width="0" x="0.833333" y="56" width="10.5" height="3.666667" stroke="#111"/>
      </g>
    </g>
  </g>
</template>

<script>
import ScaledPosition from '../utils/scaled_position'

export default {
  data() { return {
    position: new ScaledPosition({
      rawX: 0.5,
      rawY: 0.8,
      scalerX: this.parentWidth,
      scalerY: this.parentHeight,
      offsetX: -this.width / 2,
      offsetY: -this.height / 2,
      limit: {
        left: this.width / 2,
        top: this.height / 2,
        right: this.parentWidth - this.width / 2,
        bottom: this.parentHeight - this.height / 2,
      },
    }),
    whites: [],
    blacks: [],
    selectedNote: -1,
    performing: false,
    startLoc: null,
    startCursor: null,
  } },
  props: {
    width: { default: 560 },
    height: { default: 120 },
    parentWidth: { default: 800 },
    parentHeight: { default: 600 },
    lastNote: { default: null },
  },
  watch: {
    parentWidth(newVal, oldVal) { this.updatePosition() },
    parentHeight(newVal, oldVal) { this.updatePosition() },
  },
  computed: {
    pianoPos() {
      return `translate(${this.x},${this.y})`
    },
  },
  methods: {
    updatePosition() {
      this.position.rescale(this.parentWidth, this.parentHeight)
      this.position.limit.right = this.parentWidth - this.width / 2
      this.position.limit.bottom = this.parentHeight - this.height / 2
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
    },
    playFromKey(e) {
      if (e.repeat) return
      const baseOctave = 12
      const note = {
        0x41: baseOctave+0,
        0x53: baseOctave+2,
        0x44: baseOctave+4,
        0x46: baseOctave+5,
        0x47: baseOctave+7,
        0x48: baseOctave+9,
        0x4A: baseOctave+11,
        0x4B: baseOctave+12,
        0x4C: baseOctave+14,
      }[e.keyCode]
      if (note) {
        e.preventDefault()
        this.play(note)
      }
    },

    beginMoving(e) {
      this.startCursor = { x: e.pageX, y: e.pageY }
      this.startLoc = { x: this.position.scaledX, y: this.position.scaledY }
      document.addEventListener('mousemove', this.moving, false)
      document.addEventListener('mouseup', this.endMoving, false)
    },
    moving(e) {
      this.position.scaledX = this.startLoc.x + (e.pageX - this.startCursor.x)
      this.position.scaledY = this.startLoc.y + (e.pageY - this.startCursor.y)
    },
    endMoving(e) {
      this.startCursor = this.startLoc = null
      document.removeEventListener('mousemove', this.moving, false)
      document.removeEventListener('mouseup', this.endMoving, false)
    },
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
    window.addEventListener('keydown', this.playFromKey, false)
  }
}
</script>

<style scoped lang="stylus">
g.piano-mover
  cursor: move

g.white-key rect.piano-key-bg
  fill: url(#pianoWhiteKeyBg)
  stroke: #000

g.white-key.last rect.piano-key-bg
  fill: #fcc
g.black-key.last rect.piano-key-bg
  fill: #600

g.selected rect.piano-key-bg
  fill: red !important
</style>
