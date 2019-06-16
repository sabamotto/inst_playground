<template>
<div class="head">タイトル: {{ title }}</div>
</template>

<script>
export default {
  name: 'playground',
  data () {
    return {
      title: 'This is Playground.vue!!'
    }
  }
}
</script>

<style lang="stylus">
  .head
    font-size: 12px
    pointer-events: none
    user-select: none
</style>
