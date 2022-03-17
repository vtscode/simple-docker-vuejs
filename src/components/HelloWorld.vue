<template>
  <div class="hello">
    <div style="padding:40px;">
      <h1>
        Halo
        <span style="color:#29558C">Riventus</span>
      </h1>
      <p>
        It is good to have you here this is a Simple Page in
        <span class="bg-info">Vue JS</span> and Running on
        <span class="bg-success">Docker Container</span>
      </p>
    </div>
  </div>
</template>
<script>
import axios from 'axios'

export default {
  name: "HelloWorld",
  props: {
    msg: String
  },
  mounted() {
    axios.get('https://jsonplaceholder.typicode.com/users')
      .then(response => response.json())
      .then(json => console.log(json))
  }
};
</script>
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>