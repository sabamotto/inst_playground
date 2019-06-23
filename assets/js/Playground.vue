<template>
  <section class="game-root floating">
    <div class="head floating">Music Instrument Playground: {{ title }}</div>
    <svg class="playground">
      <g @click="showConfirm=true" transform="translate(20,0)" style="cursor:pointer">
        <rect width=240 height=32 fill="#ccc"></rect>
        <text x=120 y=20 width=240 height=32 text-anchor="middle" fill="black">Show confirmation modal</text>
      </g>
      <Piano x=20 y=60 @play-note="playPianoNote" :last-note="lastNote"></Piano>
    </svg>

    <confirm v-if="showConfirm" @cancel="showConfirm=false" @ok="showConfirm=false">
      <div slot="header">Test Modal</div>
      <div slot="body">Confimation Modal!</div>
    </confirm>
  </section>
</template>

<script>
import socket from "./socket"
let channel = socket.channel('playground:global', {})

import openWebPiano from "./inst/OpenWebPiano"
const gAudioContext = window.AudioContext || window.webkitAudioContext
let audioContext = new gAudioContext()
openWebPiano.init(audioContext)

import Piano from './inst/Piano.vue'
export default {
  name: 'playground',
  data() { return {
    showConfirm: false,
    lastNote: null,
  }},
  props: {
    title: 'This is Playground.vue!!',
  },
  methods: {
    playPianoNote(note) {
      channel.push('note', {scale: note})
      // openWebPiano.noteOn(note, 100)
    },
  },
  components: {
    Piano
  },
  mounted() {
    channel.on('note', payload => {
      if (!payload.scale) return
      this.lastNote = payload.scale - 48
      openWebPiano.noteOn(payload.scale, 80)
    })
    channel.join()
      .receive('ok', resp => console.log('Joined global channel'))
      .receive('error', resp => console.log('Failed to join channel'))
  }
}
</script>

<style lang="stylus">
svg.playground
  circle
    transition: all .25s ease-out
    fill: #a66
    stroke: #333
    stroke-width: 1px
    &:hover
      fill: #e99
      stroke-width: 2px
</style>
