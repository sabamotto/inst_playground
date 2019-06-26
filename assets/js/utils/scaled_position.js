export default class ScaledPosition {
  constructor(args={}) {
    this.rawX = args.rawX || 0
    this.rawY = args.rawY || 0
    this.scalerX = args.scalerX || 1
    this.scalerY = args.scalerY || 1
    this.offsetX = args.offsetX || 0
    this.offsetY = args.offsetY || 0
    this.limit = args.limit || {
      left: null, right: null,
      top: null, bottom: null,
    }
  }

  get scaledX() { return this.rawX * this.scalerX }
  get scaledY() { return this.rawY * this.scalerY }
  set scaledX(n) { this.rawX = n / this.scalerX }
  set scaledY(n) { this.rawY = n / this.scalerY }

  get x() {
    let val = this.scaledX
    if (this.limit.left !== null && val <= this.limit.left) return this.limit.left + this.offsetX
    if (this.limit.right !== null && val >= this.limit.right) return this.limit.right + this.offsetX
    return val + this.offsetX
  }
  get y() {
    let val = this.scaledY
    if (this.limit.top !== null && val <= this.limit.top) return this.limit.top + this.offsetY
    if (this.limit.bottom !== null && val >= this.limit.bottom) return this.limit.bottom + this.offsetY
    return val + this.offsetY
  }

  rescale(newSX=1, newSY=1, fixed='raw') {
    if (fixed === 'scaled') {
      this.rawX = this.scaledX / newSX
      this.rawY = this.scaledY / newSY
    }
    this.scalerX = newSX
    this.scalerY = newSY
  }

  getTransform() {
    return `translate(${this.x},${this.y})`
  }
}
