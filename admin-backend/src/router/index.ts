import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/scheduling-policy'
    },
    {
      path: '/scheduling-policy',
      name: 'scheduling-policy',
      component: () => import('../views/SchedulingPolicyView.vue')
    },
    {
      path: '/resource-pool',
      name: 'resource-pool',
      component: () => import('../views/ResourcePoolView.vue')
    },
    {
      path: '/compute-node',
      name: 'compute-node',
      component: () => import('../views/ComputeNodeView.vue')
    }
  ]
})

export default router
