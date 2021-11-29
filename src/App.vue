<template>
  <nav class="navbar">
    <router-link to="/" class="logo">
      <img alt="Vue logo" src="./assets/logo.svg" class="logo-img" />
      <div class="logo-name">Build Collective</div>
    </router-link>
    <div class="navbar-items" v-if="store.state.account.address">
      <router-link to="/account" class="navbar-item">Account</router-link>
    </div>
  </nav>
  <router-view />
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { useStore } from 'vuex'

export default defineComponent({
  name: 'App',
  setup() {
    const store = useStore()
    return { store }
  },
})
</script>

<style lang="css">
* {
  box-sizing: border-box;
}

body {
  margin: 0;
}

html {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  font-weight: 600;
  background: rgb(241, 240, 240);
  color: rgb(255, 255, 255);
}

.navbar {
  display: flex;
  background: rgba(206, 206, 206, 0.2);
  border-bottom: 2px solid;
  border-image: linear-gradient(
      to right,
      rgba(224, 218, 218, 0.5),
      rgba(79, 231, 236, 0.5)
    )
    1;
}

.logo {
  display: flex;
  align-items: center;
  padding: 12px;
  color: inherit;
  text-decoration: none;
  font-variant: small-caps;
}

.logo-img {
  width: 30px;
  margin-right: 12px;
}

.logo-name {
  font-size: 24px;
}

.navbar-items {
  display: flex;
  align-items: center;
  flex: 1;
  justify-content: flex-end;
}

.navbar-item {
  padding: 12px;
  color: inherit;
  text-decoration: none;
  font-weight: bold;
  font-size: 0.8rem;
  text-transform: uppercase;
}

#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
</style>
