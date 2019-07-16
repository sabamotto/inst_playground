<template>
  <section class="game-root floating">
    <div class="head floating">Music Instrument Playground: {{ title }}</div>
    <svg class="playground">
      <g @click="showConfirm=true" transform="translate(16,20)" style="cursor:pointer">
        <rect width=240 height=32 fill="#ccc"></rect>
        <text x=120 y=20 width=240 height=32 text-anchor="middle" fill="black">Show confirmation modal</text>
      </g>

      <Player v-for="(player, index) in players" :key="index" :parent-width="width" :parent-height="height"></Player>

      <Piano x=20 y=60 :parent-width="width" :parent-height="height" @play-note="playPianoNote" :last-note="lastNote"></Piano>
    </svg>

    <confirm v-if="showConfirm" @cancel="showConfirm=false" @ok="showConfirm=false">
      <div slot="header">Connect Server</div>
      <div slot="body">Connect to the server to share your playing. Are you ok?</div>
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
import Player from './Player.vue'
export default {
  name: 'playground',
  data() { return {
    width: 640,
    height: 480,
    showConfirm: false,
    lastNote: null,
    channel: null,
    connected: false,
    players: [{}],
  }},
  props: {
    title: 'This is Playground.vue!!',
  },
  methods: {
    updateSize() {
      this.width = this.$el.clientWidth
      this.height = this.$el.clientHeight
    },
    playPianoNote(note) {
      channel.push('note', {scale: note})
      // openWebPiano.noteOn(note, 100)
    },
  },
  components: {
    Piano, Player
  },
  mounted() {
    this.updateSize()
    window.addEventListener('resize', this.updateSize, false)

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

<style lang="stylus" scoped>
circle
  transition: all .25s ease-out
  fill: #a66
  stroke: #333
  stroke-width: 1px
  &:hover
    fill: #e99
    stroke-width: 2px
</style>
