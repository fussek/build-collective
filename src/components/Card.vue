<template>
  <div class="wrapper" :class="blue ? 'blue-gradient' : 'violet-gradient'">
    <div class="card" :class="gradient && !blue ? 'gradient' : 'opaque'">
      <div>
        <div class="card-title" :class="blue ? 'blue' : 'violet'" v-if="title">
          {{ title }}
        </div>
        <div
          class="card-subtitle"
          :class="blue ? 'blue' : 'violet'"
          v-if="subtitle"
        >
          {{ subtitle }}
        </div>
      </div>
      <div class="body">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Card',
  props: {
    title: String,
    subtitle: String,
    gradient: Boolean,
    blue: Boolean,
  },
}
</script>

<style lang="css" scoped>
.wrapper {
  border-radius: 22px;
  padding: 2px;
  display: flex;
}

.violet-gradient {
  background: linear-gradient(
    to bottom,
    rgba(26, 18, 31, 0),
    70%,
    rgba(79, 231, 236, 0.5)
  );
}

.blue-gradient {
  background: linear-gradient(
    to bottom,
    rgba(26, 18, 31, 0),
    70%,
    rgba(79, 231, 236, 0.5)
  );
}

.card {
  flex: 1;
  display: flex;
  flex-direction: column;
  border-radius: 20px;
  overflow: hidden;
  margin: 20px auto;
  box-shadow: 15px 20px 0px rgba(0, 0, 0, 0.2);
}

.opaque {
  background: rgb(212, 212, 212);
}

.gradient {
  background: linear-gradient(
    to bottom,
    rgb(210, 210, 210),
    99%,
    rgba(167, 79, 236, 0)
  );
}

.card-title,
.card-subtitle {
  padding: 18px;
}

.violet {
  background: rgb(102, 205, 205);
}

.blue {
  background: rgb(54, 187, 187);
}

.card-title {
  padding-bottom: 3px;
  font-size: 1.5rem;
  font-weight: bold;
}

.card-subtitle {
  padding-top: 0px;
  font-size: 1.2rem;
  font-weight: 500;
  color: rgb(240, 240, 240);
  white-space: pre;
}

.body {
  flex: 1;
}
</style>
