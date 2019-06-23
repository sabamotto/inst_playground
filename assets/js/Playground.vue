<template>
  <section class="game-root floating">
    <div class="head floating">Music Instrument Playground: {{ title }}</div>
    <svg class="playground">
      <g @click="showConfirm=true" transform="translate(100,0)" style="cursor:pointer">
        <rect width=240 height=32 fill="#ccc"></rect>
        <text x=120 y=20 width=240 height=32 text-anchor="middle" fill="black">Show confirmation modal</text>
      </g>
      <Piano x=100 y=100></Piano>
    </svg>

    <confirm v-if="showConfirm" @cancel="showConfirm=false" @ok="showConfirm=false">
      <div slot="header">Test Modal</div>
      <div slot="body">Confimation Modal!</div>
    </confirm>
  </section>
</template>

<script>
import Piano from './inst/Piano.vue'

export default {
  name: 'playground',
  data() { return {
    showConfirm: false,
  }},
  props: {
    title: 'This is Playground.vue!!',
  },
  components: {
    Piano
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
