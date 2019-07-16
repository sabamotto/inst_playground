<template>
  <g :transform="position.getTransform()">
    <g class="user-icon" @mousedown="beginMoving">
      <circle r="20" cx="0" cy="-5" fill="#cccccc"/>
      <path d="M-8,0 L8,0 L12,20 L-12,20z" fill="#cccccc"/>
    </g>

    <rect x="-40" y="25" width="80" height="16" fill="#222"/>
    <text class="username" x="0" y="37" width="80" height="16" text-anchor="middle" fill="#ddf">{{ username }}</text>
  </g>
</template>

<script>
import ScaledPosition from './utils/scaled_position'

export default {
  name: 'Player',
  data() { return {
    position: new ScaledPosition({
      rawX: 0.5,
      rawY: 0.4,
      scalerX: this.parentWidth,
      scalerY: this.parentHeight,
    }),
  } },
  props: {
    username: { default: 'NONAME' },
    instrument: { default: 0 },
    parentWidth: { default: 800 },
    parentHeight: { default: 600 },
  },
  watch: {
    parentWidth(newVal, oldVal) { this.updatePosition() },
    parentHeight(newVal, oldVal) { this.updatePosition() },
  },
  methods: {
    updatePosition() {
      this.position.rescale(this.parentWidth, this.parentHeight)
      this.position.limit.right = this.parentWidth - this.width / 2
      this.position.limit.bottom = this.parentHeight - this.height / 2
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
    window.addEventListener('mouseup', e => this.performing=false, false)
  }
}
</script>

<style lang="stylus" scoped>
.user-icon
  cursor: move

text.username
  font-size: 11px
  cursor: default
</style>
