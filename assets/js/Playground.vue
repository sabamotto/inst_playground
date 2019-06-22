<template>
  <section class="game-root floating playground">
    <div class="head floating">Music Instrument Playground: {{ title }}</div>
    <svg class="game-field"></svg>
  </section>
</template>

<script>
  export default {
    name: 'playground',
    data() { return {
      // title: this.title,
    }},
    props: {
      title: {
        type: String,
        default: 'This is Playground.vue!!',
      }
    }
  }
</script>
