<template>
  <transition name="modal" appear>
    <div class="modal-mask" @click.self="$emit('cancel')">
      <div class="modal-wrapper">
        <div class="modal-container">

          <div class="modal-header">
            <slot name="header">
            </slot>
          </div>

          <div class="modal-body">
            <slot name="body">
            </slot>
          </div>

          <div class="modal-footer">
            <slot name="footer">
              <button class="modal-default-button" @click="$emit('ok')">{{ ok }}</button>
              <button class="modal-default-button" @click="$emit('cancel')">{{ cancel }}</button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  props: {
    ok: {default: 'OK'},
    cancel: {default: 'Cancel'},
  }
}
</script>

<style scoped lang="stylus">
.modal-mask
  display: flex
  align-items: center
  justify-content: center
  position: fixed
  z-index: 19998
  top: 0
  left: 0
  width: 100%
  height: 100%
  background-color: rgba(0, 0, 0, .5)
  transition: opacity .3s ease

.modal-container
  width: 300px
  margin: 0px auto
  padding: 20px 30px
  background-color: #fff
  border-radius: 2px
  box-shadow: 0 2px 8px rgba(0, 0, 0, .33)
  transition: all .3s ease
  font-family: Helvetica, Arial, sans-serif

.modal-header h3
  margin-top: 0
  color: #42b983

.modal-body
  margin: 20px 0

.modal-default-button
  float: right
  margin-right: 4px

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter
  opacity: 0

.modal-leave-active
  opacity: 0

.modal-enter .modal-container,
.modal-leave-active .modal-container
  -webkit-transform: scale(1.1)
  transform: scale(1.1)
</style>
