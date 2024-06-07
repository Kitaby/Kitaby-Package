import Head from 'next/head'
import Image from 'next/image'
import { useRouter } from 'next/router'
import React, { ReactElement } from 'react'
import CardBox from '../components/CardBox'
import LayoutGuest from '../layouts/Guest'
import SectionMain from '../components/Section/Main'
import { gradientBgPurplePink } from '../colors'
import { appTitle } from '../config'
import { useAppDispatch } from '../stores/hooks'
import { setDarkMode } from '../stores/darkModeSlice'
import { useEffect } from 'react';

const StyleSelectPage = () => {
  const dispatch = useAppDispatch()

  dispatch(setDarkMode(false))

  const styles = ['white', 'basic']

  const router = useRouter()

  const handleStylePick = (style: string) => {
    document.documentElement.classList.forEach((token) => {
      if (token.indexOf('style') === 0) {
        document.documentElement.classList.replace(token, `style-${style}`)
      }
    })
    router.push('/dashboard')
  }

  // Automatically select a style and navigate to the dashboard when the component mounts
  useEffect(() => {
    handleStylePick('white'); // replace 'white' with your default style
  }, []);

  return (
    <></>
  )
}

StyleSelectPage.getLayout = function getLayout(page: ReactElement) {
  return <LayoutGuest>{page}</LayoutGuest>
}

export default StyleSelectPage