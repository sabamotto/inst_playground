<template>
  <section class="game-root floating">
    <div class="head floating">Music Instrument Playground: {{ title }}</div>
    <svg class="playground">
      <circle @click="showConfirm=true" cx=100 cy=100 r=50></circle>
    </svg>

    <confirm v-if="showConfirm" @cancel="showConfirm=false" @ok="showConfirm=false">
      <div slot="header">Test Modal</div>
      <div slot="body">Confimation Modal!</div>
    </confirm>
  </section>
</template>

<script>
  export default {
    name: 'playground',
    data() { return {
      showConfirm: false,
    }},
    props: {
      title: 'This is Playground.vue!!',
    },
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
